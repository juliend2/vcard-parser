
class Contact
  attr_accessor :vcard_string, :full_name, :nom, :prenom, :organisation, :email, :tel, :fax, :adresse, :note, :jabber, :aim

  def initialize(vcard)
    @vcard_string = vcard

    # NOM ET PRENOM:
    m_name = vcard.match(/^N:(.*);;;/)
    if m_name && m_name[1] != ';'
      (@nom,@prenom) = m_name[1].split(';')
    end
    # FULL NAME:
    @full_name = vcard.match(/^FN:(.*)/)[1]
    # ORGANISATION:
    m_organisation = vcard.match(/^ORG:(.*);/)
    @organisation = m_organisation[1] if m_organisation
    # EMAIL
    m_email = vcard.match(/^(item\d.EMAIL|EMAIL).*type=pref:(.*)/)
    @email = m_email[2] if m_email
    # JABBER
    m_jabber = vcard.match(/^X-JABBER.*type=pref:(.*)/)
    @jabber = m_jabber[1] if m_jabber
    # AIM
    m_aim = vcard.match(/^X-AIM.*type=pref:(.*)/)
    @aim = m_aim[1] if m_aim
    puts m_email.length if m_email
    #
    # TODO: faire en sorte que les contacts qui ont plus d'une adresse email
    # soient pris en compte, comme patricia et yegor par exemple
    #
  end
end

File.open('vCards.vcf').read.split("END:VCARD\nBEGIN:VCARD").each do |vcard|
  contact = Contact.new(vcard)

end

