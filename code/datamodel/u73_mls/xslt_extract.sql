declare
  v_response  varchar2(32767) := 
'<?xml version="1.0"?>
<RETS ReplyCode="0" ReplyText="Operation Successful Reference ID: 5e42730f-a7d8-4bd1-9dd4-1ffb5104741a">
<DELIMITER value="09" />
<COLUMNS>	sysid	175	15	79	80	86	104	108	151	176	384	468	2308	2320	2368	3010	3187	</COLUMNS>
<DATA>	42910899	T2574846	U 04 28 19 ZZZ 000001 25570.3	1000	2452	OFFICE	6916	2013-06-13T00:00:00			Other		2000.0	SPI-UC	CENTURY 21 ELITE LOCATIONS, IN	Yes	Outstanding, affordable medical office, perfect for a sole practitioner and ready to go. Located in University Medical Park. 1,000 sq.ft. space is in excellent condition. Includes three examination rooms, doctor''s office, supply room and an ADA compliant bathroom. Shared lobby, reception and kitchen areas. Lessee to pay 40% of monthly electricity bill and 40% of monthly assessments (40% of assessments currently equals $336.40). Ready to move in and begin practicing medicine!	</DATA>
<DATA>	41210783	T2536135	U 20 29 20 663 000002 52650.0	70640	317027		103139	2012-09-17T00:00:00			Main Thoroughfare		3.5	M	ROSS MARKETING GROUP LLC	Yes	* 46,140 SF Freestanding Warehouse - Bldg. B Available for lease within  276,160 SF campus  * 18'' Clear Ceiling Height  * 5 Dock High Doors: 10'' x 12'' size (3), 8'' x 10'' size (1), 8'' x 12'' size (1)  * Concrete Block &amp; Steel Frame Warehouse  * 600 Amp Service 3-phase 277/480 volt, 2 transformers, 1,500 KVA  * Located at I-75/Adamo Dr. interchange  * Asking $3.50/SF Industrial Gross  * Also available separately on campus is a 24,500 SF office building	</DATA>
<DATA>	36926752	T2456334	1001 E.BAKER ST.  SUITE 401	672	17161	OFFICE	12712	2011-01-31T00:00:00	900	504	Main Thoroughfare	1 to 2 Years,3 to 5 Years,Pass Throughs,Tenant Pays Electric,Pet Deposit	9.0	C-1	DONNA JEAN REALTY INC	Yes	CourtYard Square is accessible from Reynolds &amp; Baker. Architecture offers open outdoor corridors with plenty of seating and secured gates at night. There is additional unpaved lot across Baker Street for large vehicles or over-flow parking.Includes W,S,G.Other Vacancies feature kitchens; data infrastructure The price listed at $9 is net  + passthru $2.06 includes water sewer and garbage.  Nice, efficient office in well kept brick building. 3 Blocks from new courthouse.  Completely built out and ready foroccupancy!!	</DATA>
<DATA>	37106654	T2458505	U 36 27 18 0SM 000000 000050	794	871		2660	2011-02-14T00:00:00		138,000	Main Thoroughfare			CN	FIRST FLA. RLTY. OF TAMPA BAY	Yes	GREAT LOCATION FOR YOUR BUSINESS, LOTS OF TRAFFIC AND LARGE NEIGHBORHOODS. CLOSE TO EVERYTHING AND THE INTERSTATE.60X225 LOT ON LONG LAKE, OFFICE OR RETAIL, VERY BUSY ROAD FOR LOTS OF EXPOSURE!!!	</DATA>
<DATA>	36558966	T2449230	U 18 32 19 20K 000000 008011	0	0		2909	2010-12-06T00:00:00	150	164,900	US Highway			CG	PAUL B. DICKMAN, INC.	Yes	.84 ACRE, 150'' ON HIGWAY 41, ZONED CG/GENERAL , EASY ACCESS TO I-75. MAY NOT PUT A GAS STATION ON PROPERTY.	</DATA>
<DATA>	36753914	T2452343	P 35 28 21 ZZZ 000005 975400	0	1208		655	2011-01-03T00:00:00		950,000	County Road				WEICHERT REALTORS YATES&amp;ASSOC	No	17.82 acres of M-1A Industrial land. Easy access to major highways. Small house located on property. Consist of 2 folios # 203244.8800 &amp; 203244.8810. adjoining 18 acres also available.	</DATA>
<DATA>	37367240	T2462903	U 24 28 17 ZZZ 000000 35570E	2400	2480	OFFICE	6466	2011-03-14T00:00:00	60	444,000	Divided Highways			M	GREAT AMERICAN REALTY	Yes	FREE STANDING 2400 SQ FT OFFICE BUILDING BUILT IN 2007 IN VETERANS PROFESSIONAL OFFICE COMPLEX: BUILDING HAS 2 ADA BATHROOMS: LARGE CONFERENCE ROOM: RECEPTION AREA: KITCHEN AREA: EXECUTIVE OFFICE: 10 FT CEILINGS THRU-OUT: MAINTENANCE FEE IS $300 PER MONTHAND INCLUDES WATER, SEWER, GARBAGE, LAWN MAINT: FEE SIMPLE OWNERSHIP: GREAT LOCATION FOR ATTORNEY, DOCTORS OR ANY PROFESSIONAL BUSINESS:	</DATA>
<DATA>	41504313	T2543300	U 22 28 22 ZZZ 000004 75130.0	0	1874		4908	2012-11-06T00:00:00	1250	720,000	Interstate			RSC-4	SIGNATURE REALTY ASSOCIATES	Yes	16 acres MOL of very buildable land., with approximately 1,250 feet of road frontage on  I-4 (N Frontage Rd) and 500 feet of frontage on North Wilder Road. Building is of unknown condition and value, has been boarded up for several years. RSC-4 and ASC-1 zoning per IMAPP. Commercial use would require re-zoning. Fire hydrant on corner of property capped with 8 inch pipe stub out for water line expansion for development(NOTE this info per verbal conversation with Plant City government and SHOULD BE VERIFIED BY POTENTIAL BUYER!)	</DATA>
<DATA>	41938401	T2553370	U 06 28 22 ZZZ 000004 64720.0	22403	22403		3270	2013-01-24T00:00:00		199,900	County Road			AS-1	COLDWELL BANKER RESIDENTIAL	Yes	This property consists of 3.9 Acres of upland a 1 acre of ponds. There are separate office which have been remodeled. The outside storage building consists of a 21,000sq. ft metal building with open sides and concrete floor also there is a modular building which maybe used for security/dwelling unit. The property is open to a side variety of commercial uses.	</DATA>
</RETS>';

  v_xslt        xmltype :=
  xmltype(
'<?xml version=''1.0''?>
  <xsl:stylesheet version="1.0"           
       xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="xml"   
     omit-xml-declaration="no"/>
     
  <xsl:template match="/RETS">
    <RETS>
       <xsl:attribute name="ReplyCode">   
           <xsl:value-of select="@ReplyCode"/>
       </xsl:attribute> 

       <xsl:attribute name="ReplyText">   
           <xsl:value-of select="@ReplyText"/>
       </xsl:attribute> 
         
       <xsl:apply-templates select="//DELIMITER"/>
       <xsl:apply-templates select="//COLUMNS"/>
       <xsl:apply-templates select="//DATA"/>
    </RETS>
  </xsl:template>
  
  <xsl:template match="DELIMITER">    
       <DELIMITER>
         <xsl:attribute name="value">   
           <xsl:value-of select="@value"/>
         </xsl:attribute> 
      </DELIMITER>
  </xsl:template>  

  <xsl:template match="COLUMNS">    
       <COLUMNS>
         <xsl:value-of select="."/>
      </COLUMNS>
  </xsl:template>

  <xsl:template match="DATA">    
       <xsl:variable name="mls_data" select="normalize-space()"/>
       <xsl:if test="starts-with($mls_data, ''41938401'')">
       <DATA>

         <xsl:value-of select="."/>
      </DATA>
      </xsl:if>
  </xsl:template>
  </xsl:stylesheet>
     ');
  v_return      xmltype;
  v_return_char varchar2(32767);
begin
  v_return := xmltype(v_response);
  v_return := v_return.transform(xsl => v_xslt);
  v_return_char := xmltype.getstringval(v_return);
  pr_rets_pkg.put_line(v_return_char);
end;
/  
