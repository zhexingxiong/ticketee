require 'spec_helper'

describe ProjectsController do

  let(:user) do
    user = Factory(:user)
    user.confirm!
    user
  end
  
  let(:project) { Factory(:project) }

  context "standard users" do
    {"new" => "get", 
    "create" => "post",
    "edit" => "get",
    "update" => "put",
    "destroy" => "delete"}.each do |action, method|    
      it "cannot access the new action" do
        sign_in(:user, user)
        send(method, action.dup, :id => project.id)
        response.should redirect_to(root_url)
        flash[:alert].should eql("You must be an admin to do that.")
      end
    end
  end

  it "displays an error for a missing project" do
    get :show, :id => "not-here"
    response.should redirect_to(projects_url)
    message = "The project you were looking for could not be found."
    flash[:alert].should eql(message)
  end
end

