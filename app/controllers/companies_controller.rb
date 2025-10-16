class CompaniesController < WebControllerBase
  def index
    @q = params[:q].to_s.strip
    scope = Company.all
    if @q.present?
      q = "%#{@q}%"
      scope = scope.left_joins(:contacts)
                   .where(
                     "companies.name ILIKE :q OR contacts.customer_name ILIKE :q OR contacts.email ILIKE :q OR contacts.phone ILIKE :q",
                     q: q
                   ).distinct
    end
    @companies = scope.includes(:user).order(created_at: :desc)
  end

  def show
    @company = Company.includes(contacts: :tickets).find(params[:id])
  end

  def new
    @company = Company.new
    @company.user_id = current_user.id if user_signed_in?
  end

  def create
    @company = Company.new(company_params)
    @company.user_id = current_user.id if user_signed_in?
    if @company.save
      redirect_to @company
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @company = Company.includes(:user).find(params[:id])
  end

  def update
    @company = Company.find(params[:id])
    if @company.update(company_params)
      redirect_to @company
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    Company.find(params[:id]).destroy
    redirect_to companies_path
  end

  private

  def company_params
    params.require(:company).permit(:name, :email, :website, :territory, :address, :street, :state, :country, :city, :zip_code)
  end
end
