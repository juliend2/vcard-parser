vCard Parser
============
This is my naive attempt at parsing an (Apple) Address-Book-exported vCard (.vcf file) into markdown files.

Motivations
-----------
Removing my dependency to Apple's Address Book.

Usage
-----
1. Open Address Book and select all your contacts (select one then ⌘-a)
2. Export a vCard by going to File > Export > Export vCard...
3. place this "vCards.vcf" file in the same directory as parse.rb
4. run `ruby parse.rb`
5. look into the newly created 'contacts' directory that should contain all your
   contacts as markdown files


Limitations
-----------
This is not exhaustive in any way:

1. It does not do any distinction between fax or phone numbers
2. same goes for email, jabber and aim addresses

