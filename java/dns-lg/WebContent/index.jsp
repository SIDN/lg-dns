
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <title>DNS Looking glass</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="">
    <meta name="author" content="">

    <!-- Le styles -->
    <link href="assets/css/bootstrap.css" rel="stylesheet">
    <link href="assets/js/google-code-prettify/prettify.css" rel="stylesheet">
    
    <style type="text/css">
      body {
        padding-top: 20px;
        padding-bottom: 40px;
      }

      /* Custom container */
      .container-narrow {
        margin: 0 auto;
        max-width: 700px;
      }
      .container-narrow > hr {
        margin: 30px 0;
      }

      /* Main marketing message and sign up button */
      .jumbotron {
        margin: 60px 0;
        text-align: center;
      }
      .jumbotron h1 {
        font-size: 72px;
        line-height: 1;
      }
      .jumbotron .btn {
        font-size: 21px;
        padding: 14px 24px;
      }

      /* Supporting marketing content */
      .marketing {
        margin: 60px 0;
      }
      .marketing p + h4 {
        margin-top: 28px;
      }
    </style>
    <link href="assets/css/bootstrap-responsive.css" rel="stylesheet">

    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
      <script src="assets/js/html5shiv.js"></script>
    <![endif]-->

    <!-- Fav and touch icons -->
    <link rel="apple-touch-icon-precomposed" sizes="144x144" href="assets/ico/apple-touch-icon-144-precomposed.png">
    <link rel="apple-touch-icon-precomposed" sizes="114x114" href="assets/ico/apple-touch-icon-114-precomposed.png">
      <link rel="apple-touch-icon-precomposed" sizes="72x72" href="assets/ico/apple-touch-icon-72-precomposed.png">
                    <link rel="apple-touch-icon-precomposed" href="assets/ico/apple-touch-icon-57-precomposed.png">
                                   <link rel="shortcut icon" href="assets/ico/favicon.png">
  </head>

  <body>

    <div class="container-narrow">

      <div class="masthead">
        <ul class="nav nav-pills pull-right">
          <li class="active"><a href="#">Home</a></li>
          <li><a href="#">About</a></li>
          <li><a href="#">Contact</a></li>
        </ul>
        <h3 class="muted">DNS Looking Glass</h3>
      </div>

      <hr>

      <div class="row-fluid intro">
        <div class="span9">
          <h4>Looking glass details</h4>
          <p>This is a DNS looking glass running on a EC2 t1.micro instance in the Amazon cloud in
          the us-east-1a (Northern Virginia) data center.
          This service was inspired by <a href="http://www.bortzmeyer.org/dns-lg-usage.html">the DNS looking glass implementation</a> but is written as a Java web application.</p>
          
          <span class="label label-important">Note:</span>
          <p>Currently only the zone file and XML format are currently supported, this is a work in progress.
          You can test the service with <a href="/dns-lg/rest/sidn.nl/any">/dns-lg/rest/sidn.nl/any</a>
          </p>
          
          <p>Details: </p>
          <ul>
          	<li>Java SE 7</li>
          	<li>Tomcat 7</li>
          	<li>Custom Java DNS library</li>
          	<li>Libunbound 1.4.18 with DNSSEC validation</li>
          	<li>Ubuntu 12.10</li>

          </ul>

          <h4>Output</h4>
          <p>Three seperate output formats are supported: zone file, XML and JSON.
          The desired type can be signaled with the use of the standard HTTP <a href="http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html">Accept</a> header.
          The default media type is text/plain.</p>
			
          <h5>Zone file</h5>
          <p>The zone file output is formatted as described in <a href="http://www.rfc-editor.org/rfc/rfc1035.txt">RFC 1035</a>
          Request zone file outout with the text/plain media type described in <a href="http://www.ietf.org/rfc/rfc2646.txt">RFC 2646</a></p>

		  <h5>XML</h5>
          <p>The XML is formatted as described in <a href="http://tools.ietf.org/html/draft-mohan-dns-query-xml-00">DNS XML internet-draft</a>
          Request XML outout with the application/xml media type described in <a href="http://www.ietf.org/rfc/rfc3023.txt">RFC 3023</a></p>
          
          <h5>JSON</h5>
          <p>The JSON output uses the element names of the XML output, request JSON output with the application/json  media type described in <a href="http://www.ietf.org/rfc/rfc4627.txt">RFC 4627</a></p>

          <h4>Example</h4>
          <p>To query for the A resource record of domain example.com and return the result in zone file format.</p>
          <pre class="prettyprint">GET: /dns-lg/rest/example.com/A HTTP/1.1
Accept:text/plain
		  </pre>
		  
		   <p>The same query but with XML format.</p>
          <pre class="prettyprint">GET: /dns-lg/rest/example.com/A HTTP/1.1
Accept:application/xml
		  </pre>
		  
		  <h4>Other DNS Looking Glasses</h4>
		<ul>
			<li><a href="http://dns-lg.net">SIDN Labs</a></li>
			<li><a href="http://dns.bortzmeyer.org/">Stéphane Bortzmeyer</a></li>
			<li><a href="http://dnslg.generic-nic.net/">Generic NIC</a></li>
			<li><a href="http://dns-lg.nlnetlabs.nl/">NLnetLabs</a></li>
		</ul>
        </div>
      </div>

      <hr>

      <div class="footer">
        <p>&copy; Maarten Wullink 2013</p>
      </div>

    </div> <!-- /container -->

    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="assets/js/jquery.js"></script>
    <script src="assets/js/bootstrap-transition.js"></script>
    <script src="assets/js/bootstrap-alert.js"></script>
    <script src="assets/js/bootstrap-modal.js"></script>
    <script src="assets/js/bootstrap-dropdown.js"></script>
    <script src="assets/js/bootstrap-scrollspy.js"></script>
    <script src="assets/js/bootstrap-tab.js"></script>
    <script src="assets/js/bootstrap-tooltip.js"></script>
    <script src="assets/js/bootstrap-popover.js"></script>
    <script src="assets/js/bootstrap-button.js"></script>
    <script src="assets/js/bootstrap-collapse.js"></script>
    <script src="assets/js/bootstrap-carousel.js"></script>
    <script src="assets/js/bootstrap-typeahead.js"></script>
	<script src="assets/js/google-code-prettify/prettify.js"></script>
  </body>
</html>
