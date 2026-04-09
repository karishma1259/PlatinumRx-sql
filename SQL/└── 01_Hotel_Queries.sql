-- Use your database first
USE your_database_name;

-- ============================================
-- 1. Last booked room for each user
-- ============================================

SELECT b.user_id, b.room_no
FROM bookings b
JOIN (
    SELECT user_id, MAX(booking_date) AS last_booking
    FROM bookings
    GROUP BY user_id
) t
ON b.user_id = t.user_id 
AND b.booking_date = t.last_booking;


-- ============================================
-- 2. Booking total bill (November 2021)
-- ============================================

SELECT bc.booking_id,
       SUM(i.item_rate * bc.item_quantity) AS total_bill
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date) = 2021 
  AND MONTH(bc.bill_date) = 11
GROUP BY bc.booking_id;


-- ============================================
-- 3. Bills > 1000 (October 2021)
-- ============================================

SELECT bc.bill_id,
       SUM(i.item_rate * bc.item_quantity) AS bill_amount
FROM booking_commercials bc
JOIN items i ON bc.item_id = i.item_id
WHERE YEAR(bc.bill_date) = 2021 
  AND MONTH(bc.bill_date) = 10
GROUP BY bc.bill_id
HAVING bill_amount > 1000;


-- ============================================
-- 4. Most & Least ordered item (2021)
-- ============================================

WITH item_data AS (
    SELECT 
        MONTH(bill_date) AS month,
        item_id,
        SUM(item_quantity) AS total_qty
    FROM booking_commercials
    WHERE YEAR(bill_date) = 2021
    GROUP BY MONTH(bill_date), item_id
),
ranked AS (
    SELECT *,
           RANK() OVER (PARTITION BY month ORDER BY total_qty DESC) AS most_rank,
           RANK() OVER (PARTITION BY month ORDER BY total_qty ASC) AS least_rank
    FROM item_data
)

SELECT month, item_id, total_qty, 'MOST ORDERED' AS type
FROM ranked WHERE most_rank = 1

UNION ALL

SELECT month, item_id, total_qty, 'LEAST ORDERED'
FROM ranked WHERE least_rank = 1;


-- ============================================
-- 5. 2nd highest bill customer each month
-- ============================================

WITH bill_data AS (
    SELECT 
        MONTH(bc.bill_date) AS month,
        b.user_id,
        SUM(i.item_rate * bc.item_quantity) AS total_bill
    FROM booking_commercials bc
    JOIN bookings b ON bc.booking_id = b.booking_id
    JOIN items i ON bc.item_id = i.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), b.user_id
),
ranked AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY month ORDER BY total_bill DESC) AS rnk
    FROM bill_data
)

SELECT * 
FROM ranked
WHERE rnk = 2;
