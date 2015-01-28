class Api::UsersController < ApplicationController
  def index
    users = User.order('full_name')
    if params[:show_if_tagged_by]
      users = users.select('users.*, t.id as tag_id')
        .joins('left outer join (select id, tagged_id from tag_alongs where tagger_id = '+params[:show_if_tagged_by]+') as t on t.tagged_id = users.id')
    else
      users = users.select('users.*, null as tagged_id')
    end
    if params[:search_string]
      users = users.where('lower(users.full_name) like ? or lower(users.email) like ? or lower(users.username) like ?', '%'+params[:search_string].downcase+'%', '%'+params[:search_string].downcase+'%', '%'+params[:search_string].downcase+'%')
    end
    if params[:exclude_user]
      users = users.where('users.id != ?', params[:exclude_user])
    end
    if params[:in_list]
      users = users.where('users.id in (?)', params[:in_list].map{ |i| i.to_i })
    end
    if params[:not_in_list]
      users = users.where('users.id not in (?)', params[:not_in_list].map{ |i| i.to_i })
    end
    if params[:not_tagged_by]
      users = users.where('users.id not in (select t.tagged_id from tag_alongs as t where t.tagger_id = ?)', params[:not_tagged_by])
    end
    if params[:tagged_by]
      users = users.where('users.id in (select t.tagged_id from tag_alongs as t where t.tagger_id = ?)', params[:tagged_by])
    end

    resp = Base.list_response('users', users.length, users)
    render json: resp
  end
end
