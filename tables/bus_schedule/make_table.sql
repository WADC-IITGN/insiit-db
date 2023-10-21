-- Creating the table bus_schedule with non-reserved column names
CREATE TABLE bus_schedule (
    id SERIAL PRIMARY KEY,
    from_location VARCHAR NOT NULL,
    to_location VARCHAR NOT NULL,
    departure_time TIME NOT NULL,
    via VARCHAR NOT NULL,
    capacity INT NOT NULL
);


-- Create a new function to validate JSON for bus_schedule
CREATE OR REPLACE FUNCTION validate_json_bus_schedule()
RETURNS TRIGGER AS $$
DECLARE
    via_array JSON; -- Declare a JSON variable for 'via' validation
BEGIN
    -- Validate 'via' JSON field
    via_array := NEW.via;
    
    -- Check if 'via' is an array
    IF NOT JSON_TYPEOF(via_array) = 'array' THEN
        RAISE EXCEPTION 'via must be an array';
    END IF;

    -- Loop through the 'via' array and validate each element
    FOR via_element IN SELECT * FROM JSON_ARRAY_ELEMENTS(via_array)
    LOOP
        -- Check if each element is a string
        IF NOT JSON_TYPEOF(via_element) = 'string' THEN
            RAISE EXCEPTION 'Each element in via array must be a string';
        END IF;

        -- Additional validation rules can be added for via elements here
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to validate JSON for bus_schedule
CREATE TRIGGER validate_json_bus_schedule
BEFORE INSERT OR UPDATE ON bus_schedule
FOR EACH ROW
EXECUTE FUNCTION validate_json_bus_schedule();
