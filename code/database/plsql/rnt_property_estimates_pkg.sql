CREATE OR REPLACE PACKAGE rnt_property_estimates_pkg
AS
/***************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PROPERTY_ESTIMATES_PKG
    Purpose:   API's for RNT_PROPERTY_ESTIMATES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        02-APR-08   Auto Generated   Initial Version
***************************************************************************/
   type estimate_rowtype        rnt_property_estimates%rowtype;

   function get_estimate_data(
      x_property_id             in    rnt_property_estimates.property_estimates_id%TYPE,
      x_end_date                in date) return estimate_rowtype;        

   FUNCTION get_checksum (
      x_property_estimates_id   IN   rnt_property_estimates.property_estimates_id%TYPE
   )
      RETURN rnt_property_estimates_v.checksum%TYPE;

   PROCEDURE update_row (
      x_property_estimates_id   IN   rnt_property_estimates.property_estimates_id%TYPE,
      x_property_id             IN   rnt_property_estimates.property_id%TYPE,
      x_business_id             IN   rnt_property_estimates.business_id%TYPE,
      x_estimate_year           IN   rnt_property_estimates.estimate_year%TYPE,
      x_estimate_title          IN   rnt_property_estimates.estimate_title%TYPE,
      x_monthly_rent            IN   rnt_property_estimates.monthly_rent%TYPE,
      x_other_income            IN   rnt_property_estimates.other_income%TYPE,
      x_vacancy_pct             IN   rnt_property_estimates.vacancy_pct%TYPE,
      x_replace_3years          IN   rnt_property_estimates.replace_3years%TYPE,
      x_replace_5years          IN   rnt_property_estimates.replace_5years%TYPE,
      x_replace_12years         IN   rnt_property_estimates.replace_12years%TYPE,
      x_maintenance             IN   rnt_property_estimates.maintenance%TYPE,
      x_utilities               IN   rnt_property_estimates.utilities%TYPE,
      x_property_taxes          IN   rnt_property_estimates.property_taxes%TYPE,
      x_insurance               IN   rnt_property_estimates.insurance%TYPE,
      x_mgt_fees                IN   rnt_property_estimates.mgt_fees%TYPE,
      x_down_payment            IN   rnt_property_estimates.down_payment%TYPE,
      x_closing_costs           IN   rnt_property_estimates.closing_costs%TYPE,
      x_purchase_price          IN   rnt_property_estimates.purchase_price%TYPE,
      x_cap_rate                IN   rnt_property_estimates.cap_rate%TYPE,
      x_loan1_amount            IN   rnt_property_estimates.loan1_amount%TYPE,
      x_loan1_type              IN   rnt_property_estimates.loan1_type%TYPE,
      x_loan1_term              IN   rnt_property_estimates.loan1_term%TYPE,
      x_loan1_rate              IN   rnt_property_estimates.loan1_rate%TYPE,
      x_loan2_amount            IN   rnt_property_estimates.loan2_amount%TYPE,
      x_loan2_type              IN   rnt_property_estimates.loan2_type%TYPE,
      x_loan2_term              IN   rnt_property_estimates.loan2_term%TYPE,
      x_loan2_rate              IN   rnt_property_estimates.loan2_rate%TYPE,
      x_notes                   IN   rnt_property_estimates.notes%TYPE,
      x_checksum                IN   rnt_property_estimates_v.checksum%TYPE
   );

   FUNCTION insert_row (
      x_property_id       IN   rnt_property_estimates.property_id%TYPE,
      x_business_id       IN   rnt_property_estimates.business_id%TYPE,
      x_estimate_year     IN   rnt_property_estimates.estimate_year%TYPE,
      x_estimate_title    IN   rnt_property_estimates.estimate_title%TYPE,
      x_monthly_rent      IN   rnt_property_estimates.monthly_rent%TYPE,
      x_other_income      IN   rnt_property_estimates.other_income%TYPE,
      x_vacancy_pct       IN   rnt_property_estimates.vacancy_pct%TYPE,
      x_replace_3years    IN   rnt_property_estimates.replace_3years%TYPE,
      x_replace_5years    IN   rnt_property_estimates.replace_5years%TYPE,
      x_replace_12years   IN   rnt_property_estimates.replace_12years%TYPE,
      x_maintenance       IN   rnt_property_estimates.maintenance%TYPE,
      x_utilities         IN   rnt_property_estimates.utilities%TYPE,
      x_property_taxes    IN   rnt_property_estimates.property_taxes%TYPE,
      x_insurance         IN   rnt_property_estimates.insurance%TYPE,
      x_mgt_fees          IN   rnt_property_estimates.mgt_fees%TYPE,
      x_down_payment      IN   rnt_property_estimates.down_payment%TYPE,
      x_closing_costs     IN   rnt_property_estimates.closing_costs%TYPE,
      x_purchase_price    IN   rnt_property_estimates.purchase_price%TYPE,
      x_cap_rate          IN   rnt_property_estimates.cap_rate%TYPE,
      x_loan1_amount      IN   rnt_property_estimates.loan1_amount%TYPE,
      x_loan1_type        IN   rnt_property_estimates.loan1_type%TYPE,
      x_loan1_term        IN   rnt_property_estimates.loan1_term%TYPE,
      x_loan1_rate        IN   rnt_property_estimates.loan1_rate%TYPE,
      x_loan2_amount      IN   rnt_property_estimates.loan2_amount%TYPE,
      x_loan2_type        IN   rnt_property_estimates.loan2_type%TYPE,
      x_loan2_term        IN   rnt_property_estimates.loan2_term%TYPE,
      x_loan2_rate        IN   rnt_property_estimates.loan2_rate%TYPE,
      x_notes             IN   rnt_property_estimates.notes%TYPE
   )
      RETURN rnt_property_estimates.property_id%TYPE;

   PROCEDURE delete_row (
      x_property_estimates_id   IN   rnt_property_estimates.property_estimates_id%TYPE
   );
END rnt_property_estimates_pkg;
/

SHOW ERRORS;

CREATE OR REPLACE PACKAGE BODY rnt_property_estimates_pkg
AS
/***************************************************************************
   Copyright (c) Visulate 2007        All rights reserved worldwide
    Name:      RNT_PROPERTY_ESTIMATES_PKG
    Purpose:   API's for RNT_PROPERTY_ESTIMATES table
    Revision History
    Ver        Date        Author           Description
    --------   ---------   ---------------- ---------------------
    1.0        02-APR-08   Auto Generated   Initial Version

****************************************************************************/
-------------------------------------------------
--  Private Procedures and Functions
-------------------------------------------------
   PROCEDURE lock_row (
      x_property_estimates_id   IN   rnt_property_estimates.property_estimates_id%TYPE
   )
   IS
      CURSOR c
      IS
         SELECT     *
               FROM rnt_property_estimates
              WHERE property_estimates_id = x_property_estimates_id
         FOR UPDATE NOWAIT;
   BEGIN
      OPEN c;

      CLOSE c;
   EXCEPTION
      WHEN OTHERS
      THEN
         IF SQLCODE = -54
         THEN
            raise_application_error
                                  (-20001,
                                   'Cannot changed record. Record is locked.'
                                  );
         END IF;
   END lock_row;

   FUNCTION check_unique (
      x_property_id             rnt_property_estimates.property_id%TYPE,
      x_business_id             rnt_property_estimates.business_id%TYPE,
      x_estimate_year           rnt_property_estimates.estimate_year%TYPE,
      x_estimate_title          rnt_property_estimates.estimate_title%TYPE,
      x_property_estimates_id   rnt_property_estimates.property_estimates_id%TYPE
   )
      RETURN BOOLEAN
   IS
      x   NUMBER;
   BEGIN
      SELECT 1
        INTO x
        FROM DUAL
       WHERE EXISTS (
                SELECT 1
                  FROM rnt_property_estimates
                 WHERE (   property_estimates_id != x_property_estimates_id
                        OR x_property_estimates_id IS NULL
                       )
                   AND property_id = x_property_id
                   AND business_id = x_business_id
                   AND estimate_year = x_estimate_year
                   AND estimate_title = x_estimate_title);

      RETURN FALSE;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         RETURN TRUE;
   END;

-------------------------------------------------
--  Public Procedures and Functions
-------------------------------------------------

   function get_estimate_data(
      x_property_id             in    rnt_property_estimates.property_estimates_id%TYPE,
      x_end_date                in date) return estimate_rowtype is




   function get_potential_rent(
      x_property_id             in    rnt_property_estimates.property_estimates_id%TYPE,
      x_end_date                in date) return number is

     cursor cur_unit (x_property_id   in    rnt_property_estimates.property_estimates_id%TYPE) is
      select unit_id
      from rnt_property_units
      where property_id = x_property_id;

     cursor cur_agreement( 
      x_unit_id                 in    rnt_property_units.unit_id%TYPE,
      x_end_date                in date)
      select date_available
      ,      agreement_date
      ,      amount
      ,      amount_period
      ,      end_date
      from rnt_tenancy_agreement
      where unit_id = x_unit_id
      and agreement_date between add_months(x_end_date, -12) and x_end_date
      order by date_available;

      v_return_value     number := 0;

   begin
  
      for u_rec in cur_unit(x_property_id) loop
        for a_rec in cur_agreement( x_unit_id      => u_rec.unit_id
                                  , x_date         => x_end_date ) loop





   end get_potential_rent;

   FUNCTION get_checksum (
      x_property_estimates_id   IN   rnt_property_estimates.property_estimates_id%TYPE
   )
      RETURN rnt_property_estimates_v.checksum%TYPE
   IS
      v_return_value   rnt_property_estimates_v.checksum%TYPE;
   BEGIN
      SELECT checksum
        INTO v_return_value
        FROM rnt_property_estimates_v
       WHERE property_estimates_id = x_property_estimates_id;

      RETURN v_return_value;
   END get_checksum;

   PROCEDURE update_row (
      x_property_estimates_id   IN   rnt_property_estimates.property_estimates_id%TYPE,
      x_property_id             IN   rnt_property_estimates.property_id%TYPE,
      x_business_id             IN   rnt_property_estimates.business_id%TYPE,
      x_estimate_year           IN   rnt_property_estimates.estimate_year%TYPE,
      x_estimate_title          IN   rnt_property_estimates.estimate_title%TYPE,
      x_monthly_rent            IN   rnt_property_estimates.monthly_rent%TYPE,
      x_other_income            IN   rnt_property_estimates.other_income%TYPE,
      x_vacancy_pct             IN   rnt_property_estimates.vacancy_pct%TYPE,
      x_replace_3years          IN   rnt_property_estimates.replace_3years%TYPE,
      x_replace_5years          IN   rnt_property_estimates.replace_5years%TYPE,
      x_replace_12years         IN   rnt_property_estimates.replace_12years%TYPE,
      x_maintenance             IN   rnt_property_estimates.maintenance%TYPE,
      x_utilities               IN   rnt_property_estimates.utilities%TYPE,
      x_property_taxes          IN   rnt_property_estimates.property_taxes%TYPE,
      x_insurance               IN   rnt_property_estimates.insurance%TYPE,
      x_mgt_fees                IN   rnt_property_estimates.mgt_fees%TYPE,
      x_down_payment            IN   rnt_property_estimates.down_payment%TYPE,
      x_closing_costs           IN   rnt_property_estimates.closing_costs%TYPE,
      x_purchase_price          IN   rnt_property_estimates.purchase_price%TYPE,
      x_cap_rate                IN   rnt_property_estimates.cap_rate%TYPE,
      x_loan1_amount            IN   rnt_property_estimates.loan1_amount%TYPE,
      x_loan1_type              IN   rnt_property_estimates.loan1_type%TYPE,
      x_loan1_term              IN   rnt_property_estimates.loan1_term%TYPE,
      x_loan1_rate              IN   rnt_property_estimates.loan1_rate%TYPE,
      x_loan2_amount            IN   rnt_property_estimates.loan2_amount%TYPE,
      x_loan2_type              IN   rnt_property_estimates.loan2_type%TYPE,
      x_loan2_term              IN   rnt_property_estimates.loan2_term%TYPE,
      x_loan2_rate              IN   rnt_property_estimates.loan2_rate%TYPE,
      x_notes                   IN   rnt_property_estimates.notes%TYPE,
      x_checksum                IN   rnt_property_estimates_v.checksum%TYPE
   )
   IS
      l_checksum   rnt_property_estimates_v.checksum%TYPE;
   BEGIN
      lock_row (x_property_id);
      -- validate checksum
      l_checksum := get_checksum (x_property_estimates_id);

      IF x_checksum != l_checksum
      THEN
         raise_application_error (-20002,
                                  'Record has been changed another user.'
                                 );
      END IF;

      IF NOT check_unique (x_property_id,
                           x_business_id,
                           x_estimate_year,
                           x_estimate_title,
                           x_property_estimates_id
                          )
      THEN
         raise_application_error
            (-20580,
             'Estimation must be unique (found same combination <BUSINESS_UNIT, PROPERTY, ESTIMATION YEAR, ESTIMATION TITLE>)'
            );
      END IF;

      UPDATE rnt_property_estimates
         SET business_id = x_business_id,
             estimate_year = x_estimate_year,
             estimate_title = x_estimate_title,
             monthly_rent = x_monthly_rent,
             other_income = x_other_income,
             vacancy_pct = x_vacancy_pct,
             replace_3years = x_replace_3years,
             replace_5years = x_replace_5years,
             replace_12years = x_replace_12years,
             maintenance = x_maintenance,
             utilities = x_utilities,
             property_taxes = x_property_taxes,
             insurance = x_insurance,
             mgt_fees = x_mgt_fees,
             down_payment = x_down_payment,
             closing_costs = x_closing_costs,
             purchase_price = x_purchase_price,
             cap_rate = x_cap_rate,
             loan1_amount = x_loan1_amount,
             loan1_type = x_loan1_type,
             loan1_term = x_loan1_term,
             loan1_rate = x_loan1_rate,
             loan2_amount = x_loan2_amount,
             loan2_type = x_loan2_type,
             loan2_term = x_loan2_term,
             loan2_rate = x_loan2_rate,
             notes = x_notes
       WHERE property_estimates_id = x_property_estimates_id;
   END update_row;

   FUNCTION insert_row (
      x_property_id       IN   rnt_property_estimates.property_id%TYPE,
      x_business_id       IN   rnt_property_estimates.business_id%TYPE,
      x_estimate_year     IN   rnt_property_estimates.estimate_year%TYPE,
      x_estimate_title    IN   rnt_property_estimates.estimate_title%TYPE,
      x_monthly_rent      IN   rnt_property_estimates.monthly_rent%TYPE,
      x_other_income      IN   rnt_property_estimates.other_income%TYPE,
      x_vacancy_pct       IN   rnt_property_estimates.vacancy_pct%TYPE,
      x_replace_3years    IN   rnt_property_estimates.replace_3years%TYPE,
      x_replace_5years    IN   rnt_property_estimates.replace_5years%TYPE,
      x_replace_12years   IN   rnt_property_estimates.replace_12years%TYPE,
      x_maintenance       IN   rnt_property_estimates.maintenance%TYPE,
      x_utilities         IN   rnt_property_estimates.utilities%TYPE,
      x_property_taxes    IN   rnt_property_estimates.property_taxes%TYPE,
      x_insurance         IN   rnt_property_estimates.insurance%TYPE,
      x_mgt_fees          IN   rnt_property_estimates.mgt_fees%TYPE,
      x_down_payment      IN   rnt_property_estimates.down_payment%TYPE,
      x_closing_costs     IN   rnt_property_estimates.closing_costs%TYPE,
      x_purchase_price    IN   rnt_property_estimates.purchase_price%TYPE,
      x_cap_rate          IN   rnt_property_estimates.cap_rate%TYPE,
      x_loan1_amount      IN   rnt_property_estimates.loan1_amount%TYPE,
      x_loan1_type        IN   rnt_property_estimates.loan1_type%TYPE,
      x_loan1_term        IN   rnt_property_estimates.loan1_term%TYPE,
      x_loan1_rate        IN   rnt_property_estimates.loan1_rate%TYPE,
      x_loan2_amount      IN   rnt_property_estimates.loan2_amount%TYPE,
      x_loan2_type        IN   rnt_property_estimates.loan2_type%TYPE,
      x_loan2_term        IN   rnt_property_estimates.loan2_term%TYPE,
      x_loan2_rate        IN   rnt_property_estimates.loan2_rate%TYPE,
      x_notes             IN   rnt_property_estimates.notes%TYPE
   )
      RETURN rnt_property_estimates.property_id%TYPE
   IS
      x   NUMBER;
   BEGIN
      IF NOT check_unique (x_property_id,
                           x_business_id,
                           x_estimate_year,
                           x_estimate_title,
                           NULL
                          )
      THEN
         raise_application_error
            (-20580,
             'Estimation must be unique (found same combination <BUSINESS_UNIT, PROPERTY, ESTIMATION YEAR, ESTIMATION TITLE>)'
            );
      END IF;

      INSERT INTO rnt_property_estimates
                  (property_estimates_id, property_id,
                   business_id, estimate_year, estimate_title,
                   monthly_rent, other_income, vacancy_pct,
                   replace_3years, replace_5years, replace_12years,
                   maintenance, utilities, property_taxes, insurance,
                   mgt_fees, down_payment, closing_costs,
                   purchase_price, cap_rate, loan1_amount,
                   loan1_type, loan1_term, loan1_rate, loan2_amount,
                   loan2_type, loan2_term, loan2_rate, notes
                  )
           VALUES (rnt_property_estimates_seq.NEXTVAL, x_property_id,
                   x_business_id, x_estimate_year, x_estimate_title,
                   x_monthly_rent, x_other_income, x_vacancy_pct,
                   x_replace_3years, x_replace_5years, x_replace_12years,
                   x_maintenance, x_utilities, x_property_taxes, x_insurance,
                   x_mgt_fees, x_down_payment, x_closing_costs,
                   x_purchase_price, x_cap_rate, x_loan1_amount,
                   x_loan1_type, x_loan1_term, x_loan1_rate, x_loan2_amount,
                   x_loan2_type, x_loan2_term, x_loan2_rate, x_notes
                  )
        RETURNING property_estimates_id
             INTO x;

      RETURN x;
   END insert_row;

   PROCEDURE delete_row (
      x_property_estimates_id   IN   rnt_property_estimates.property_estimates_id%TYPE
   )
   IS
   BEGIN
      DELETE FROM rnt_property_estimates
            WHERE property_estimates_id = x_property_estimates_id;
   END delete_row;
END rnt_property_estimates_pkg;
/

SHOW ERRORS;
