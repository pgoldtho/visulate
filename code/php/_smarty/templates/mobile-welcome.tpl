{assign var="contactHeader" value="Welcome to Visulate"}

{if !($displayLocation)}
{assign var="displayLocation" value="Florida"}
{assign var="contactHeader" value="Contact Us"}
{/if}
{assign var="contactTitle" value="$displayLocation Real Estate Investing"}
{assign var="contactText" value="<p>My name is Sue Goldthorp, owner and co-founder of Visulate.   Visulate is a real estate brokerage specializing in Florida real estate investment.</p><p>We've been investing in Florida real estate since 2003 and have worked with all types of investor from private equity firms to individuals saving for retirement.</p>"}
{assign var="callToAction" value="Contact us to discuss your real estate investment goals"}


{assign var="emailSubject" value="$contactTitle"}
{assign var="emailBody" value="I am interested in $displayLocation real estate"}


{if ($propid)}
{assign var="contactText" value="<p>Visulate is a real estate brokerage based in Mims, Florida. We have assembled a database with details of every property in Florida. Finding the property on our site does not necessarily mean it is for sale or rent at this time.</p>"}
{assign var="emailBody" value="Reference property: http://visulate.com/property/$propid"}
{assign var="emailSubject" value="$address1, $displayLocation"}
{/if}

{if ($mlsID)}
{assign var="contactHeader" value="Find Out More"}
{assign var="contactTitle" value="Contact Sue for additional details"}
{assign var="contactText" value="<p>Use the buttons below to send me a message.  I'll respond as soon as possible.  Please include the city in your message.  My site has listings for all of Florida</p>"}
{assign var="callToAction" value="Let me help you"}
{/if}

<h3>{$contactHeader}</h3>
<img src="/images/sue_sm.png" style="border: 1px solid #949494;  margin: 5px; "/>

<h3>{$contactTitle}</h3>
{$contactText}

<h4>{$callToAction}</h4>
<a href="mailto:sales@visulate.com?subject={$emailSubject}&body={$emailBody}"
   class="ui-btn ui-btn-icon-left ui-icon-mail">Email</a>
<a href="sms:1-321-453-7389" class="ui-btn ui-btn-icon-left ui-icon-comment">Text Message</a>
<a href="tel:1-321-453-7389" class="ui-btn ui-btn-icon-left ui-icon-phone">Voicemail</a>



 
        
