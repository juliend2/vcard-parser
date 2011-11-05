require './contact'

File.open('vCards.vcf').read.split("END:VCARD\nBEGIN:VCARD").each do |vcard|
  contact = Contact.new(vcard)
  puts contact.to_markdown
end
