# Todo

- **Explore tables**
    - [ ] Table set schema
    - [ ] Mocked tables
    - [ ] HTTP request for feed
    - [ ] Render feed
    - [ ] Filter feed by tags
    - [ ] Filter feed by authors
    - [ ] Print
    - [ ] "Add to favorite"
    - [ ] "Mark as trash" (spam, useless)
- **Create tables**
    - [ ] Editor for single table
    - [ ] Link table rows
    - [ ] Validate linking
- **User area**
    - [ ] Login/logout
    - [ ] Created tables
    - [ ] Favorite tables

Table set scheme:
{
    "setName": string,
    "tables": [
        "caption": string,
        "die": ["d4" | "d6" | "d8" ... | "d100"]
        "entries": [
            {
                "value": string,
                "weight": float, // calculated or direct input
                "target?": set
            },
        ]
    ]
}
