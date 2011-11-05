
class Contact
  attr_accessor :vcard_string, :full_name, :nom, :prenom, :organisation, :emails, :phones, :adresse, :note

  def initialize(vcard)
    @vcard_string = vcard
    parse(vcard)
  end

  def parse(vcard)
    # LAST NAME AND FIRST NAME
    m_name = vcard.match(/^N:(.*);;;/)
    if m_name && m_name[1] != ';'
      (@nom,@prenom) = m_name[1].split(';')
    end
    # FULL NAME:
    @full_name = vcard.match(/^FN:(.*)/)[1]
    # ORGANISATION:
    m_organisation = vcard.match(/^ORG:(.*);/)
    @organisation = m_organisation[1] if m_organisation
    # EMAILS:
    e_reg = Regexp.new(/\b[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}\b/)   
    @emails = vcard.scan(e_reg).uniq
    # PHONES (will also grab faxes, but that's OK for now):
    p_reg = Regexp.new(/\b(?:\(?(\d{3})\)?[ -]?)?(?:(\d{3})-?(\d{4}))\b/)
    @phones = vcard.scan(p_reg).uniq
    @phones.map!{|p| p.join('-')}
    # ADDRESS:
    m_address = vcard.match(/^item\d\.ADR.+type=(pref|HOME|WORK):(.*)/)
    if m_address
      @address = m_address[2]
      @address = @address.split(';')
      @address.delete('')
      @address.delete("\r")
      @address = @address.map{|elm| 
        remove_escapes(elm) 
      }.map {|elm|
        elm.chomp("\r")
      }
    end
    # NOTES:
    m_note = vcard.match(/^NOTE:(.*)/)
    @note = m_note[1] if m_note
    @note = remove_escapes(@note) if @note

  end

  private

  def remove_escapes(string)
    string.gsub(/\\n/,"\n").gsub(/\\/,'')
  end
end

File.open('vCards.vcf').read.split("END:VCARD\nBEGIN:VCARD").each do |vcard|
  contact = Contact.new(vcard)
end
