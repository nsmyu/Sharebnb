class ReservationsController < ApplicationController
  def index
    @reservations = Reservation.where(user_id: current_user.id)
  end

  def confirm
    if user_signed_in? == false
      @room = Room.find(params[:id])
      @reservation = Reservation.new
      flash.now[:notice] = "予約にはログインが必要です。右上のメニューからログインかアカウント登録をお願いします。"
      render "rooms/show" and return
    end

    if (params[:reservation][:id]).empty?
      @reservation = Reservation.new(reservation_params)
      @room = Room.find(params[:id])
      render "rooms/show" if @reservation.invalid?
    else
      @reservation = Reservation.find(params[:id])
      @reservation.attributes = reservation_params
      render "reservations/edit" if @reservation.invalid?
    end
  end

  def register
    if (params[:reservation][:id]).empty?
      @reservation = Reservation.new(reservation_params)
      @reservation.save
      flash[:notice] = "予約が完了しました。"
      redirect_to :reservations
    else
      update
    end
  end

  def edit
    @reservation = Reservation.find(params[:id])
  end

  def update
    @reservation = Reservation.find(params[:id])
    @reservation.update(reservation_params)
    flash[:notice] = "予約情報を更新しました。"
    redirect_to :reservations
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    flash[:alert] = "予約のキャンセルが完了しました。"
    redirect_to :reservations
  end

  private

  def reservation_params
    params.require(:reservation).permit(:check_in_on, :check_out_on, :num_of_people, :user_id, :room_id)
  end
end
