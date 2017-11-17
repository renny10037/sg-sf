# This file should contain all the record creation needed to seed
# the database with its default values.
# The data can then be loaded with the rake db:seed
# (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
# user = CreateAdminService.new.call
# puts 'CREATED ADMIN USER: ' << user.email

[:admin, :employee,:pending,:locked].each do |name|
  Role.create name: name
  puts "#{name} has been created"
end

User.create(
  name: 'Admin',email: 'admin@keppler.com', password: '12345678',
  password_confirmation: '12345678', role_ids: '1'
)

User.create(
  name: 'Personal de Nomina', email: 'personal_nomina@gmail.com', password: '12345678',
  password_confirmation: '12345678', role_ids: '2'
)
User.create(
  name: 'renny',last_name: 'petit',country_residence:'VE',nationality:'VE', email: 'renny10037@gmail.com',identification:'22606261', password: '12345678',
  password_confirmation: '12345678', role_ids: '2'
)
User.create(
  name: 'leonard', email: 'leonard@gmail.com',country_residence:'EQ',nationality:'EQ',identification:'22607006', password: '12345678',
  password_confirmation: '12345678', role_ids: '2')

User.create(
  name: 'marian', email: 'marian@gmail.com',identification:'17323209', password: '12345678',
  password_confirmation: '12345678', role_ids: '1')

State.create(
  name: 'Active')
State.create(
  name: 'Pause')
State.create(
 name: 'Removed')
State.create(
  name: 'Completed')

PercentageCost.create(order_id:'1',quantify:'50')
PercentageCost.create(order_id:'2',quantify:'60')
PercentageCost.create(order_id:'3',quantify:'70')
#PercentageCost.create(order_id:'4',quantify:'80')

StackBank.create(name:'100% BANCO',cod: '0156')

StackBank.create(name:'ABN AMRO BANK',cod: '0196')

StackBank.create(name:'BANCAMIGA BANCO MICROFINANCIERO, C.A.',cod: '0172')

StackBank.create(name:'100% BANCO',cod: '0156')

StackBank.create(name:'BANCO ACTIVO BANCO COMERCIAL, C.A.',cod: '0171')
    
StackBank.create(name:'BANCO AGRICOLA',cod: '0166')
    
StackBank.create(name:'BANCO BICENTENARIO',cod: '0175')
    
StackBank.create(name:'BANCO CARONI, C.A. BANCO UNIVERSAL',cod: '0128')
    
StackBank.create(name:'BANCO DE DESARROLLO DEL MICROEMPRESARIO',cod: '0164')
    
StackBank.create(name:'BANCO DE VENEZUELA S.A.I.C.A.',cod: '0102')
    
StackBank.create(name:'BANCO DEL CARIBE, C.A.',cod: '0114')
    
StackBank.create(name:'BANCO DEL PUEBLO SOBERANO, C.A.',cod: '0149')
    
StackBank.create(name:'BANCO DEL TESORO',cod: '0163')
    
StackBank.create(name:'BANCO ESPIRITO SANTO, S.A.',cod: '0176')
    
StackBank.create(name:'BANCO EXTERIOR, C.A.',cod: '0115')
    
StackBank.create(name:'BANCO INDUSTRIAL DE VENEZUELA.',cod: '0003')
    
StackBank.create(name:'BANCO INTERNACIONAL DE DESARROLLO, C.A.',cod: '0173')
    
StackBank.create(name:'BANCO MERCANTIL, C.A.',cod: '0105')
    
StackBank.create(name:'BANCO NACIONAL DE CREDITO',cod: '0191')
    
StackBank.create(name:'BANCO OCCIDENTAL DE DESCUENTO.',cod: '0116')
    
StackBank.create(name:'BANCO PLAZA',cod: '0138')
    
StackBank.create(name:'BANCO PROVINCIAL BBVA',cod: '0108')
    
StackBank.create(name:'BANCO VENEZOLANO DE CREDITO, S.A.',cod: '0104')
    
StackBank.create(name:'BANCRECER S.A. BANCO DE DESARROLLO',cod: '0168')
    
StackBank.create(name:'BANFANB',cod: '0177')
    
StackBank.create(name:'BANGENTE',cod: '0146')
    
StackBank.create(name:'BANPLUS BANCO COMERCIAL, C.A',cod: '0174')
    
StackBank.create(name:'CITIBANK',cod: '0190')   

StackBank.create(name:'DELSUR BANCO UNIVERSAL',cod: '0157')
    
StackBank.create(name:'FONDO COMÚN',cod: '0151')
    
StackBank.create(name:'INSTITUTO MUNICIPAL DE CRÉDITO POPULAR',cod: '0601')
    
StackBank.create(name:'MIBANCO BANCO DE DESARROLLO, C.A.',cod: '0169')
    
StackBank.create(name:'SOFITASA',cod: '0137')

puts 'admin@keppler.com has been created'

Customize.create(file: "", installed: true)
puts 'Keppler Template has been created'
# Create setting deafult
setting = Setting.new(
  name: 'Keppler Admin', description: 'Welcome to Keppler Admin',
  smtp_setting_attributes: {
    address: 'test', port: '25', domain_name: 'keppler.com',
    email: 'info@keppler.com', password: '12345678'
  },
  google_analytics_setting_attributes: {
    ga_account_id: '60688852',
    ga_tracking_id: 'UA-60688852-1',
    ga_status: true
  }
)
setting.social_account = SocialAccount.new
setting.appearance = Appearance.new(theme_name: 'keppler')
setting.save
puts 'Setting default has been created'
