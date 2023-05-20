// List all films
db.movies.find();

// Find those directed by Quentin Tarantino
db.movies.find(
    {writer: "Quentin Tarantino"}
)

// Finding those involving Brad Pitt
db.movies.find(
    {actors: {$in: ["Brad Pitt"]}}
)

// Find titles in the "The Hobbit" franchise
db.movies.find({ franchise: "The Hobbit" });

// Find movies released in the 90s
db.movies.find(
    {year: {$gte: 1990, $lte: 1999}}
)

// Get films released between 2000 and 2010
db.movies.find(
    {year: {$gte: 2000, $lte:2010}}
)

// Find films whose synopsis contains the word "Bilbo".
db.movies.find(
    {synopsis: /Bilbo/}
)

// Find films whose synopsis contains the word "Gandalf".
db.movies.find(
    {synopsis: /Gandalf/}
)

// Find films that contain the word "Bilbo" in the synopsis and not the word "Gandalf".
db.movies.find(
    {
        $and: [
            {synopsis: /Bilbo/},
            {synopsis: {$not : {$regex: /Gandalf/}}},
        ]
    },
)

// Find films with the word "dwarves" or "hobbit" in the synopsis.
db.movies.find(
    {
        $or: [
            {synopsis: /dwarves/},
            {synopsis: /hobbit/},
        ]
    },
)

// Find films with the word "gold" and "dragon" in the synopsis.
db.movies.find(
    {
        $and: [
            {synopsis: /gold/},
            {synopsis: /dragon/},
        ]
    },
)

// Add the following synopsis to "The Hobbit: An Unexpected Journey" :
// "A reluctant hobbit, Bilbo Baggins, sets off for the Lonely Mountain with a
// spirited band of dwarves to reclaim his mountain home - and the gold it contains - from the dragon Smaug."
db.movies.updateOne(
    { title: "The Hobbit: An Unexpected Journey" },
    {
        $set: {
            synopsis: "A reluctant hobbit, Bilbo Baggins, sets off for the Lonely Mountain with a spirited band of dwarves to reclaim his mountain home - and the gold it contains - from the dragon Smaug."
        }
    }
)

// Add the following synopsis to "The Hobbit: The Desolation of Smaug" :
// "The dwarves, along with Bilbo Baggins and Gandalf the Grey, continue their quest to reclaim Erebor,
// their homeland, from Smaug. Bilbo Baggins is in possession of a mysterious and magical ring".
db.movies.updateOne(
    { title: "The Hobbit: The Desolation of Smaug" },
    {
        $set: {
            synopsis: "The dwarves, along with Bilbo Baggins and Gandalf the Grey, continue their quest to reclaim Erebor, their homeland, from Smaug. Bilbo Baggins is in possession of a mysterious and magical ring."
        }
    }
)

// Add the actor "Samuel L. Jackson" to the film "Pulp Fiction".
db.movies.updateOne(
    { title: "Pulp Fiction" },
    {
        $push: { actors : "Samuel L. Jackson" }
    }
)

// Remove the film "Pee Wee Herman's Big Adventure".
db.movies.deleteOne(
    {title : "Pee Wee Herman's Big Adventure"}
)

// Remove the film "Avatar".
db.movies.deleteOne(
    {title : "Avatar"}
)