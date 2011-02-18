require 'spec_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to specify the controller code that
# was generated by the Rails when you ran the scaffold generator.

describe NoticesController do

  def mock_notice(stubs={})
    @mock_notice ||= mock_model(Notice, stubs).as_null_object
  end

  describe "GET index" do
    it "assigns all notices as @notices" do
      Notice.stub(:all) { [mock_notice] }
      get :index
      assigns(:notices).should eq([mock_notice])
    end
  end

  describe "GET show" do
    it "assigns the requested notice as @notice" do
      Notice.stub(:find).with("37") { mock_notice }
      get :show, :id => "37"
      assigns(:notice).should be(mock_notice)
    end
  end

  describe "GET new" do
    it "assigns a new notice as @notice" do
      Notice.stub(:new) { mock_notice }
      get :new
      assigns(:notice).should be(mock_notice)
    end
  end

  describe "GET edit" do
    it "assigns the requested notice as @notice" do
      Notice.stub(:find).with("37") { mock_notice }
      get :edit, :id => "37"
      assigns(:notice).should be(mock_notice)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "assigns a newly created notice as @notice" do
        Notice.stub(:new).with({'these' => 'params'}) { mock_notice(:save => true) }
        post :create, :notice => {'these' => 'params'}
        assigns(:notice).should be(mock_notice)
      end

      it "redirects to the created notice" do
        Notice.stub(:new) { mock_notice(:save => true) }
        post :create, :notice => {}
        response.should redirect_to(notice_url(mock_notice))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved notice as @notice" do
        Notice.stub(:new).with({'these' => 'params'}) { mock_notice(:save => false) }
        post :create, :notice => {'these' => 'params'}
        assigns(:notice).should be(mock_notice)
      end

      it "re-renders the 'new' template" do
        Notice.stub(:new) { mock_notice(:save => false) }
        post :create, :notice => {}
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested notice" do
        Notice.stub(:find).with("37") { mock_notice }
        mock_notice.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :notice => {'these' => 'params'}
      end

      it "assigns the requested notice as @notice" do
        Notice.stub(:find) { mock_notice(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:notice).should be(mock_notice)
      end

      it "redirects to the notice" do
        Notice.stub(:find) { mock_notice(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(notice_url(mock_notice))
      end
    end

    describe "with invalid params" do
      it "assigns the notice as @notice" do
        Notice.stub(:find) { mock_notice(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:notice).should be(mock_notice)
      end

      it "re-renders the 'edit' template" do
        Notice.stub(:find) { mock_notice(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested notice" do
      Notice.stub(:find).with("37") { mock_notice }
      mock_notice.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the notices list" do
      Notice.stub(:find) { mock_notice }
      delete :destroy, :id => "1"
      response.should redirect_to(notices_url)
    end
  end

end
