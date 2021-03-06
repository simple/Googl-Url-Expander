require 'rubygems'
require 'sinatra'
require 'googl'
# encoding: UTF-8

get '/' do
  erb :index
end

post '/expand' do
  short_url = params[:shortener_url] + params[:shortened_url]
  @long_url = ''
  @part = params["shortened_url"]
  begin
    @long_url = Googl.expand(short_url).long_url
  rescue
    puts "Not Found"
    halt 404
  end
  erb :index
end

post '/go' do
  short_url = params[:shortener_url] + params[:shortened_url]
  begin
    long_url = Googl.expand(short_url).long_url
  rescue
    long_url = '/'
  end
  redirect long_url
end

__END__

@@index
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<title>ggl - Expand shortened URLs</title>	
	<meta http-equiv="content-type" content="text/html;charset=UTF-8" />    
	<meta name="keywords" content=""></meta>
	<meta name="description" content="A Shortened URL Expander"></meta>
	<meta http-equiv="imagetoolbar" content="no" />
	<link rel="stylesheet" href="css/screen.css" media="screen" />
</head>
<body>

<!-- <div id="container"> -->

    <form id="form2" action="" method="post">	

        <h3><span>Expand Shortened URL</span></h3>

        <fieldset>
            <p class="first">
                http://goo.gl/
                <input type="hidden" name="shortener_url" id="shortener-url" value="http://goo.gl/">
                <input type="hidden" name="req_type" id="req-type" value="check">
                <input type="text" name="shortened_url" id="shortened-url" size="30" value="<%= @part %>"/>
               
            </p>
            <p class="first" id="expanded-url">
                 <%= @long_url%>
            </p>
            <p class="submit">
                <button type="button" id="button-expand-url">Expand</button>
                <button type="button" id="button-goto-url">Go</button>
            </p>
        </fieldset>
    </form>	
<!-- </div> -->

</body>
</html>
<script src='js/jquery-1.4.js'></script>
<script type="text/javascript">
$(document).ready(function() {
    $('#button-expand-url').click(function(e) {
        $('#req-type').attr('value', 'check');
        $('#form2').attr('action', '/expand');
        $('#form2').submit();
    });
    $('#button-goto-url').click(function(e) {
        $('#req-type').attr('value', 'redirect');
        $('#form2').attr('action', '/go');
        $('#form2').submit();
    });
    $('#shortened-url').keyup(function() {
        $('#expanded-url').text('');
    });
    $('#shortened-url').focus();
}
);

</script>