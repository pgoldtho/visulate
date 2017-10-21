<div style="clear: both;"></div>
<!-- Contact Form -->
<form method="post" action="/rental/contact.php" name="contact" >

    <div class="col-sm-12 col-md-8 col-lg-6">              
        <img src="/images/sue_sm.png" style="border: 1px solid #949494; 
             float: left; margin-right: 5px; margin-bottom: 12px;" alt="Sue Goldthorp"/>

        <h4 style="margin-top:0; font-size: 28px;">I'm here to help</h4>
        <p>My name is Sue Goldthorp.  I am a real estate broker and co-founder of Visulate.   
            Drop me a line if you would like me to help you buy or sell a property in {$displayLocation}.</p>
        <p><input required type="text" name="name" placeholder="Name" aria-label="Name"/>    
            <input type="text" name="honeypot" style="display:none" value=""/></p>

        <p><input required type="tel" name="phone" 
                  {literal}pattern="(?:\(\d{3}\)|\d{3})[- ]?\d{3}[- ]?\d{4}" {/literal}
                  title='Format: (321) 453 7389'
                  placeholder="Phone" aria-label="Phone number"/></p>
        <p><input required type="email" name="email" placeholder="Email Address" 
                  {literal} pattern="[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,3}$"{/literal}
                  title="Enter a valid email address"
                  aria-label="Email address"/></p>
    </div>

    <div class="col-md-12"></div>

    <div class="col-sm-12 col-md-8 col-lg-6">
        <p><input required type="text" name="subject" placeholder="Subject" 
                  style="width: 100%;" aria-label="Subject"/></p>
        <p><textarea required name="message" placeholder="Message" rows="6" minlength="20"
                     style="width: 100%;" aria-label="Message"></textarea></p>
        <input type="submit" value="Send Message"
               style="-moz-appearance: none;
               background-color: #98c593;
               border: 0 none;
               border-radius: 3.5em;
               color: #fff;
               cursor: pointer;
               display: inline-block;
               height: 3.5em;
               line-height: 3.5em;
               outline: 0 none;
               padding: 0 2em;
               position: relative;
               text-align: center;
               text-decoration: none;"/>
    </div>

    <input type="hidden" name="url" value="http://{$smarty.server.HTTP_HOST}{$smarty.server.REQUEST_URI}"/>
    <input type="hidden" name="contactType" value="{$displayLocation}"/>
</form>
<div style="clear: both"></div>

