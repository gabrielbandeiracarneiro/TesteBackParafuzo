class Parking < ApplicationRecord
    #Validação do padrão de placa
    validates :plate, presence: true, format: { with: /\A[a-zA-Z]{3}-(\d{4}|[0-9][a-zA-Z]\d{2})\z/,message: "is invalid"}
    
    #Validando se o veículo não encontra-se no estacionamento
    validate :plateOnParking, on: :create

    private
    def plateOnParking
        parkings = Parking.where(plate:self.plate,left:false).order('created_at DESC')
        
        #verificando se existe registros
		if(parkings.length!=0)	
            errors.add :plate, message: "already parked"
		end
    end
end
