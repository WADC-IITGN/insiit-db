-- Insert bus stops with additional parameters
INSERT INTO bus_stops ("name","distance_from_iitgn")
VALUES
    ('IITGN', 0.0),
    ('Rakshashakti Circle', 2.5),
    ('VGEC Gate', 5.2),
    ('Visat Circle', 7.8);

-- Insert bus schedules with JSON data for 'via' using the new structure
INSERT INTO bus_schedule
    ("from_location", "to_location", "departure_time", "via", "capacity")
VALUES
    (1, 4, '8:00:00', '[{"stop": 1, "arrival_time": "08:00:00"}, {"stop": 2, "arrival_time": "08:20:00"}, {"stop": 3, "arrival_time": "08:35:00"}, {"stop": 4, "arrival_time": "08:50:00"}]', 56);
