

CREATE OR REPLACE VIEW travel_bookings.analytics.customer_360 AS
SELECT
  -- Customer dimension attributes (current version only)
  d.customer_sk,                    -- Surrogate key for joins
  d.customer_id,                    -- Natural key from source system
  d.customer_name,                  -- Customer name
  d.customer_address,               -- Customer address
  d.email,                          -- Customer email
  
  -- Booking type for segmentation
  f.booking_type,                   -- Type of booking (flight, hotel, etc.)
  
  -- Lifetime customer metrics
  SUM(f.total_amount_sum) AS lifetime_amount,    -- Total amount spent
  SUM(f.total_quantity_sum) AS lifetime_quantity -- Total bookings made

FROM travel_bookings.default.customer_dim d
JOIN travel_bookings.default.booking_fact f
  ON f.customer_sk <=> d.customer_sk  -- Join on surrogate key (handles nulls)
WHERE d.is_current = true              -- Only current customer records
GROUP BY d.customer_sk, d.customer_id, d.customer_name, d.customer_address, d.email, f.booking_type;