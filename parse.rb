require './contact'

INPUT_FILENAME = 'vCards.vcf'
DIRNAME = 'contacts'

begin
  Dir::mkdir(DIRNAME)
rescue
  puts "the '#{DIRNAME}' directory already exists"
end

File.open(INPUT_FILENAME).read.split("END:VCARD\nBEGIN:VCARD").each do |vcard|
  contact = Contact.new(vcard)
  output_file_name = contact.full_name.downcase.strip.gsub(/\W/, '-').chomp('-') + ".md"
  File.open("#{DIRNAME}/#{output_file_name}", 'w') {|f| 
    f.write(contact.to_markdown)
  }
end
