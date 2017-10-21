set define '^'

begin

pr_records_pkg.insert_deed_code( x_deed_code   =>'AG'
                               , x_description =>'Articles Of Agreement Deed'
                               , x_definition  => 'Articles-of-Agreement for Deed refers to a type of seller financing which allows the buyer to purchase the home in installments over a specified period of time. The seller keeps legal title to the home until the loan is paid off. The buyer receives an interest in the property—called equitable title—but does not own it. However, because the buyer is paying the real estate taxes and paying interest to the seller, it is the buyer who receives the tax benefits of home ownership.');

pr_records_pkg.insert_deed_code( x_deed_code   =>'CA'
                               , x_description =>'Civil Action'
                               , x_definition  => ' ');

pr_records_pkg.insert_deed_code( x_deed_code   =>'CD'
                               , x_description =>'County Deed'
                               , x_definition  => ' ');

pr_records_pkg.insert_deed_code( x_deed_code   =>'CE'
                               , x_description =>'Conservation/Esmt 706.04'
                               , x_definition  => ' ');

pr_records_pkg.insert_deed_code( x_deed_code   =>'CN'
                               , x_description =>'Contract'
                               , x_definition  => ' ');

pr_records_pkg.insert_deed_code( x_deed_code   =>'CO'
                               , x_description =>'Co-Op'
                               , x_definition  => 'A form of ownership of real property where legal title is vested in a corporation or other entity an the beneficial use is evidenced by an ownership interest in the association and a lease or other muniment of title or possession granted by teh association as teh owner of all the cooperative property.');

pr_records_pkg.insert_deed_code( x_deed_code   =>'CT'
                               , x_description =>'Certificate Of Title'
                               , x_definition  => 'A written statement by an attorney or title company as to the status of a property title.');

pr_records_pkg.insert_deed_code( x_deed_code   =>'DB'
                               , x_description =>'Deed Book'
                               , x_definition  => ' ');

pr_records_pkg.insert_deed_code( x_deed_code   =>'FJ'
                               , x_description =>'Final Judgement'
                               , x_definition  => ' ');

pr_records_pkg.insert_deed_code( x_deed_code   =>'GD'
                               , x_description =>'Grant Deed Or Guardian Deed'
                               , x_definition  => 'A grant deed transfers to the grantee all or part of the legal rights the grantor has in the parcel of real property.  The grantor deed implies certain warranties; that the property has not been transferred to someone else and that the property is free from any liens placed on the property by the grantor.');

pr_records_pkg.insert_deed_code( x_deed_code   =>'LS'
                               , x_description =>'Lease'
                               , x_definition  => ' ');

pr_records_pkg.insert_deed_code( x_deed_code   =>'NN'
                               , x_description =>'Sale Disqualified'
                               , x_definition  => ' ');

pr_records_pkg.insert_deed_code( x_deed_code   =>'PR'
                               , x_description =>'Personal Representative'
                               , x_definition  => ' ');

pr_records_pkg.insert_deed_code( x_deed_code   =>'PT'
                               , x_description =>'Part (Multiple Parcels Included In Deed)'
                               , x_definition  => ' ');

pr_records_pkg.insert_deed_code( x_deed_code   =>'QC'
                               , x_description =>'Quit Claim'
                               , x_definition  => 'A quit claim deed transfers to the grantee any and all of the legal rights the grantor has in the parcel of real property.  The quit claim deed makes no warranty about the extent of the grantor''s interest in the parcel of real property.');

pr_records_pkg.insert_deed_code( x_deed_code   =>'RD'
                               , x_description =>'Road Right-Of-Way'
                               , x_definition  => ' ');

pr_records_pkg.insert_deed_code( x_deed_code   =>'SD'
                               , x_description =>'Sheriff Deed'
                               , x_definition  => 'A deed given to a buyer of property purchased at a sheriff''s sale');

pr_records_pkg.insert_deed_code( x_deed_code   =>'TD'
                               , x_description =>'Trustee Deed'
                               , x_definition  => 'A trust deed is a written instrument which transfers property to a trustee to secure an obligation such as a promissory note or a mortgage.  The trustee has the power to sell the real property in the case of a default on the obligation.');

pr_records_pkg.insert_deed_code( x_deed_code   =>'UD'
                               , x_description =>'Unit Deed'
                               , x_definition  => 'A deed conveying a condominium unit.');

pr_records_pkg.insert_deed_code( x_deed_code   =>'WD'
                               , x_description =>'Warranty Deed/Special Warranty Deed'
                               , x_definition  => 'A warranty deed transfers to the grantee all of the legal rights the grantor has in the parcel of real property and explicitly warranties that the grantor has good title to the parcel. A special warranty deed warranties only what the deed specifically states is warranted.');

pr_records_pkg.insert_deed_code( x_deed_code   =>'XD'
                               , x_description =>'Tax Deed'
                               , x_definition  => 'The deed to the government-claimed property of a delinquent taxpayer that is conveyed to the purchaser at a public sale.');
end;
/