# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(page_title, show_title = true)
    @content_for_title = page_title.to_s
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => "flash-#{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end

  def locale_link(locale, locale_desc)
     locale_text = "#{locale_desc} (#{locale})"
     options =  { :locale => "#{locale}" }
     if I18n.locale == locale
       "#{locale_desc} (#{locale})"
     else
       link_to locale_text,
       url_for( {:controller => self.controller_name, :action => self.action_name}.merge(options) )
     end
  end

#  def get_current_time
#     Time.zone="Hong Kong"
#     Time.now
#  end

  def params_for_filters
    output_params = {}
    [:category, :posting_type, :origin].each do |f|
      if params[f]
        output_params[f] = params[f]
      end
    end
    output_params
  end

  def google_analytics_tag
    analytics_includes = <<-ANALYTICS
      var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
      document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
    ANALYTICS
    analytics = <<-ANALYTICS
      try {
      var pageTracker = _gat._getTracker("UA-11174738-1");
      pageTracker._trackPageview();
      } catch(err) {}
    ANALYTICS
    javascript_tag(analytics_includes)+javascript_tag(analytics)
  end

  def feedback_tag
    feedback_includes = <<-IFEEDBACK
      var uservoiceJsHost = ("https:" == document.location.protocol) ? "https://uservoice.com" : "http://cdn.uservoice.com";
      document.write(unescape("%3Cscript src='" + uservoiceJsHost + "/javascripts/widgets/tab.js' type='text/javascript'%3E%3C/script%3E"))
    IFEEDBACK
    feedback = <<-FEEDBACK
      UserVoice.Tab.show({
        /* required */
        key: 'neiworld',
        host: 'neiworld.uservoice.com',
        forum: '31561',
        /* optional */
        alignment: 'left',
        background_color:'#f00',
        text_color: 'white',
        hover_color: '#06C',
        lang: 'en'
      })
    FEEDBACK
    javascript_tag(feedback_includes)+javascript_tag(feedback)
  end

end