require 'zip/zip'
# require 'zip/zipfilesystem'

class FiscalYear < ActiveRecord::Base
  has_many :postings, :dependent => :destroy
  has_many :transactions, :dependent => :destroy
  belongs_to :user
  
  validates_presence_of :name, :start_date, :end_date
  
  # download an archive of all annexes associated with this fiscal year
  def zip_annexes
    # some_file_list = [File.new(RAILS_ROOT + '/poster.csv')]
    
    t = Tempfile.new("some-weird-temp-file-basename")
    
    # Give the path of the temp file to the zip outputstream, it won't try to open it as an archive.
    Zip::ZipOutputStream.open(t.path) do |zos|
      transactions.all(:include => :annexes).each do |transaction|
        transaction.annexes.each do |annex|
          content = read_annex_content(annex)
          
          if content
            # Create a new entry with some arbitrary name
            zos.put_next_entry("#{'%04d' % transaction.attachment_no}-#{transaction.note.parameterize.to_s[0, 80]}-#{annex.id}")
            
            # Add the contents of the file, don't read the stuff linewise if its binary, instead use direct IO
            zos.write content
          end
        end
      end
      
      # some_file_list.each do |file|
      #   # Create a new entry with some arbitrary name
      #   zos.put_next_entry(File.basename(file.path))
      #   # Add the contents of the file, don't read the stuff linewise if its binary, instead use direct IO
      #   zos.print IO.read(file.path)
      # end
    end
    # End of the block  automatically closes the file.
    
    t
  end
  
  private
  
  def read_annex_content(annex)
    open(annex.authenticated_url).read
  rescue
    Rails.logger.debug("Unable to read #{annex.inspect}")
    nil
  end
end
