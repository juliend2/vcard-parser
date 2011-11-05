class Contact
  attr_accessor :vcard_string, :full_name, :lastname, :firstname, :title, :organisation, :emails, :phones, :url, :address, :note

  def initialize(vcard)
    @vcard_string = vcard
    parse(vcard)
  end

  def parse(vcard)
    # LAST NAME AND FIRST NAME
    m_name = vcard.match(/^N:(.*);;;/)
    if m_name && m_name[1] != ';'
      (@lastname,@firstname) = m_name[1].split(';')
    end
    # FULL NAME:
    @full_name = vcard.match(/^FN:(.*)/)[1].chomp("\r")
    # TITLE:
    m_title = vcard.match(/^TITLE:(.*)/)
    @title = m_title[1] if m_title
    # ORGANISATION:
    m_organisation = vcard.match(/^ORG:(.*);/)
    @organisation = m_organisation[1] if m_organisation
    # URL:
    m_url = vcard.match(/^(item\d\.URL|URL).*type=pref:(.*)/)
    @url = remove_escapes(m_url[2]) if m_url
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

  def to_markdown
    out = %{#{@full_name}
#{'='*@full_name.size}

}
    out << "Name: #{get_name}\n" if get_name.strip != ''
    out << "Organisation: #{@organisation}\n" if @organisation
    out << "Title: #{@title}\n" if @title
    out << "Site: #{@url}\n" if @url

    out << %{
Emails
------
#{@emails.map{|e| "* #{e}"}.join("\n")}
} unless @emails.empty?

    out << %{
Phones
------
#{@phones.map{|p| "* #{p}"}.join("\n")}
} unless @phones.empty?

    out << %{
Address
-------
#{@address.join("\n")}
} if @address
    
    out << %{
Note
----
#{@note}
} if @note

    out
  end

  def get_name
    "#{@firstname} #{@lastname}"
  end

  private

  def remove_escapes(string)
    string.gsub(/\\n/,"\n").gsub(/\\/,'')
  end
end
