class Admin::CategoriesController < Admin::BaseController
  cache_sweeper :blog_sweeper

  def index; redirect_to :action => 'new' ; end

  #GET /admin/categories/new
  def new
    puts "New called"
    @category = Category.new
    @categories = Category.find(:all)
    p @category
    #new_or_edit
  end

  #POST /admin/categories/edit
  def edit
    debugger

    if params[:id] != nil
      @category = Category.find(params[:id]) 
      @category.attributes = params[:category] 
    else
      @category = Category.new
    end

    new_or_edit
  end

  def new_or_edit 
    @categories = Category.find(:all)

    if request.post?  
      @category = Category.new(params[:category])

      respond_to do |format|
        if @category.save
          format.html do
            flash[:notice] = _('Category was successfully saved.')
            #redirect_to(@category, :notice => "Category was successfully created")
            redirect_to :action => "new"
            return
          end 
          format.js do 
            @category.save
            @article = Article.new
            @article.categories << @category
            return render(:partial => 'admin/content/categories')
          end
        else
          format.html do
            flash[:error] = _('Category could not be saved.')
            redirect_to :action => "new"
            return 
          end
        end
      end
    else
      respond_to do |format|
        format.html do
          render :action => "new"
        end
        format.js { 
          @category = Category.new
        }
      end
    end
  end

  def create
  end

  def destroy
    @record = Category.find(params[:id])
    return(render 'admin/shared/destroy') unless request.post?

    @record.destroy
    redirect_to :action => 'new'
  end

  private

  def save_category
    if @category.save!
      flash[:notice] = _('Category was successfully saved.')
    else
      flash[:error] = _('Category could not be saved.')
    end
    redirect_to :action => 'new'
  end

end
