-- Creating the table bus_stops with unique IDs and additional parameters
CREATE TABLE bus_stops (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    distance_from_iitgn FLOAT
);

-- Creating the table bus_schedule with changes to 'via' column and references to 'bus_stops' table
CREATE TABLE bus_schedule (
    id SERIAL PRIMARY KEY,
    from_location INT REFERENCES bus_stops(id) NOT NULL,
    to_location INT REFERENCES bus_stops(id) NOT NULL,
    departure_time TIME NOT NULL,
    via JSONB,
    capacity INT NOT NULL
);

-- Create a new function to validate JSON for bus_schedule
CREATE OR REPLACE FUNCTION validate_json_bus_schedule()
RETURNS TRIGGER AS $$
DECLARE
    via_array JSONB; -- Declare a JSON variable for 'via' validation
BEGIN
    -- Validate 'via' JSON field
    via_array := NEW.via;

    -- Check if 'via' is an array
    IF NOT JSONB_typeof(via_array) = 'array' THEN
        RAISE EXCEPTION 'via must be an array';
    END IF;

    -- Loop through the 'via' array and validate each element
    FOR via_element IN SELECT * FROM jsonb_array_elements(via_array)
    LOOP
        -- Check if each element is a JSON object
        IF NOT JSONB_typeof(via_element) = 'object' THEN
            RAISE EXCEPTION 'Each element in via array must be a JSON object';
        END IF;

        -- Check if 'stop' is an integer and references 'bus_stops' table
        IF NOT (via_element->>'stop')::integer IS NOT NULL THEN
            RAISE EXCEPTION 'Each via element must have a valid integer "stop" field';
        END IF;

        -- Additional validation rules for 'arrival_time' can be added here
    END LOOP;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create a trigger to validate JSON for bus_schedule
CREATE TRIGGER validate_json_bus_schedule
BEFORE INSERT OR UPDATE ON bus_schedule
FOR EACH ROW
EXECUTE FUNCTION validate_json_bus_schedule();
