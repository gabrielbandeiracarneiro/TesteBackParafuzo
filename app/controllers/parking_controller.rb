require 'base64'
class ParkingController < ApplicationController
    # Listar todos os registros de estacionamento
    def index
        parkings = Parking.order('created_at DESC');
        render json: parkings,status: :ok
    end

    # Listar estacionamento de uma placa
    def show
        parking = Parking.select(:id,:time,:paid,:left,:reservation).where(plate:params[:id]).order('created_at DESC')
        render json: parking,status: :ok
    end

    # Entrada de um novo veículo
    def create
       
        parking = Parking.new(parking_params)
        parking.entryDate=Time.now
        parking.time=""
        parking.paid=false
        parking.left=false
        parking.reservation = Base64.encode64( (parking.plate+Time.now.utc.strftime('%Y/%m/%d%H:%M:%S')))
        if parking.save
            render json: {
                id: parking.id,
                plate: parking.plate,
                reservation: parking.reservation,
                entryDate:parking.entryDate
            },status: :ok
        else
            render json: {errors:parking.errors},status: :unprocessable_entity
        end
        
    end

    # Excluir um histórico de estacionamento
    def destroy
        parking = Parking.find(params[:id])
        parking.destroy
        render json: parking,status: :ok
    end

    # Atualizar um registro de estacionamento
    def update
        parking = Parking.find(params[:id])
        if parking.update_attributes(parking_params)
            render json: parking,status: :ok
        else
            render json: {errors:parking.errors},status: :unprocessable_entity
        end
    end

     # efetua o pagamento de um estacionamento
     def pay
        parking = Parking.where(plate:params[:id],paid:false).order('created_at')
        if(parking.length==0)
            render json: {errors:{plate:["O veículo não foi encontrado com pagamento pendente"]}},status: :not_found
        else
            parking = parking[0]
            parking.paidDate=Time.now
            parking.paid=true
            if parking.save
                render json: {
                    id: parking.id,
                    plate: parking.plate,
                    reservation: parking.reservation,
                    paidDate: parking.paidDate,
                    paid: parking.paid,
                    entryDate:parking.entryDate
                },status: :ok
            else
                render json: {errors:parking.errors},status: :unprocessable_entity
            end
        end
    end

    # efetua a saída de um veículo do estacionamento
    def out
        parking = Parking.where(plate:params[:id],left:false).order('created_at')
        if(parking.length==0)
            render json: {errors:{plate:["O veículo não foi encontrado com saída pendente"]}},status: :not_found
        elsif parking[0].paid==false
            render json: {errors:{plate:["Efetue o pagamento para sair com o veículo"]}},status: :unprocessable_entity

        else
            parking = parking[0]
            parking.exitDate=Time.now
            parking.left=true
            segundos = (parking.exitDate-parking.entryDate);
            if(segundos >= 86400)
                parking.time="#{'%.0f' %(segundos/86400)} days #{'%.0f' %((segundos%86400)/3600)} hours"
            elsif (segundos >= 3600)
                parking.time="#{'%.0f' %(segundos/3600)} hours #{'%.0f' %((segundos%3600)/60)} minutes"
            elsif (segundos >= 60)
                parking.time="#{'%.0f' %(segundos/60)} minutes #{'%.0f' %(segundos%60)} seconds"
            else
                parking.time="#{'%.0f' %(segundos)} seconds"
            end
            if parking.save
                render json: {
                    id: parking.id,
                    plate: parking.plate,
                    reservation: parking.reservation,
                    entryDate: parking.entryDate,
                    paidDate: parking.paidDate,
                    exitDate: parking.exitDate,
                    time: parking.time,
                    paid: parking.paid,
                    left: parking.left
                },status: :ok
            else
                render json: {errors:parking.errors},status: :unprocessable_entity
            end
        end
    end
    
    # Parametros aceitos
    private
    def parking_params
        params.permit(:plate)
    end
end