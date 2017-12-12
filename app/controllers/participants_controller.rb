class ParticipantsController < ApplicationController
  def participation
    @event = Event.find(params[:format])
  end

  def index
    if  params[:back]
      @participants = Participant.all.includes(:event).where(participant_id: params[:format])
    else
      @participants = Participant.all.includes(:event).where(participant_id: params[:id])
    end
  end

  def create
    @artist = Artist.find_by(user_id: current_user.id)
    @participant = Participant.create(event_id: params[:id], participant_id: @artist.id)

    if @participant.save
      redirect_to root_path, notice: "イベント参加が完了しました！"
    else
      redirect_to root_path, notice: "参加登録中に異常がありました。。。御手数ですが、初めからやり直してください。"
    end
  end

  def destroy
    @participant = Participant.find_by(event_id: params[:id], participant_id: current_user.artist.ids[0])
    @participant.destroy
    redirect_to events_path, notice: 'イベント参加を取り止めました。'
  end

  def confirm
    @participant = Participant.find_by(event_id: params[:id], participant_id: current_user.artist.ids[0])
  end

end
