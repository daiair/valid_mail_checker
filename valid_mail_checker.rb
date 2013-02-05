# Valid mail checker
#
# This program is a tool for checking mail adresses are valid or not.
#
# !!CAUTION!!
# 1) DO NOT use for spaming or other bad things.
# 2) DO NOT use for too many email adresses. SMTP server will block you and networks.

require 'net/smtp'
require 'resolv'

#Capsuling to use MAIL FROM and RCPT TO.
class Net::SMTP
  def mail_from(from_addr)
    mailfrom(from_addr)
  end

  def rcpt_to(to_addr)
    rcptto(to_addr)
  end
end

HELO = "localhost"
MAILFROM = "info@localhost"

mail_adress = ARGV[0]
unless mail_adress =~ /^([a-zA-Z0-9])+([a-zA-Z0-9\._-])*@([a-zA-Z0-9_-])+([a-zA-Z0-9\._-]+)+$/
  puts "This mail adress is not valid syntax."
  exit
end
mail_domain = (mail_adress.split '@')[1]

resolver = Resolv::DNS.new
mx_domain = (resolver.getresource mail_domain, Resolv::DNS::Resource::IN::MX).exchange.to_s

Net::SMTP.start(mx_domain, 25, HELO) do |smtp|
  begin
    smtp.mail_from MAILFROM
  rescue
    puts "Server retern error at MAIL FROM."
    exit
  end

  begin
    smtp.rcpt_to mail_adress
  rescue
    puts "#{mail_adress} is not exist."
    exit
  end
end

puts "#{mail_adress} seems to be exist."

