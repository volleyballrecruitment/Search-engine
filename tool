<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>College Search Tool</title>
  <style>
    body {
      font-family: Arial, sans-serif;
      margin: 20px;
    }
    h1, h2 {
      text-align: center;
    }
    form {
      max-width: 500px;
      margin: 0 auto 20px auto;
      padding: 20px;
      border: 1px solid #ccc;
      border-radius: 5px;
    }
    label {
      display: block;
      margin-top: 10px;
    }
    input[type="text"] {
      width: 100%;
      padding: 8px;
      margin-top: 5px;
    }
    button {
      margin-top: 15px;
      padding: 10px 20px;
      background-color: #0073e6;
      color: white;
      border: none;
      border-radius: 3px;
      cursor: pointer;
    }
    button:hover {
      background-color: #005bb5;
    }
    .result {
      border: 1px solid #ddd;
      padding: 15px;
      margin-bottom: 15px;
      border-radius: 5px;
    }
    .result a {
      color: #0073e6;
      text-decoration: none;
    }
    .result a:hover {
      text-decoration: underline;
    }
    #results {
      max-width: 600px;
      margin: 0 auto;
    }
  </style>
</head>
<body>

  <h1>College Search</h1>
  <form id="searchForm">
    <label for="collegeName">College Name (optional):</label>
    <input type="text" id="collegeName" name="collegeName" placeholder="Enter college name">
    
    <label for="state">State (2-letter code, optional):</label>
    <input type="text" id="state" name="state" placeholder="e.g. CA">
    
    <button type="submit">Search</button>
  </form>
  
  <h2>Results</h2>
  <div id="results" style="text-align:center;">Enter a search term above.</div>

  <script>
    document.getElementById("searchForm").addEventListener("submit", function(e) {
      e.preventDefault();
      
      // Get input values
      const collegeName = document.getElementById("collegeName").value.trim();
      const state = document.getElementById("state").value.trim();
      
      // Your College Scorecard API key – replace with your actual key.
      const apiKey = "dgkNT0ZaDgETwAVsVEDvvGdDjnDG1U2O8OWNgmC7";
      
      // Base URL for the College Scorecard API (returns JSON)
      let apiUrl = `https://api.data.gov/ed/collegescorecard/v1/schools.json?api_key=${apiKey}`;
      
      // Add filters based on input values (if provided)
      if (collegeName) {
        // Filter by college name
        apiUrl += `&school.name=${encodeURIComponent(collegeName)}`;
      }
      if (state) {
        // Filter by state (using the two-letter code)
        apiUrl += `&school.state=${encodeURIComponent(state)}`;
      }
      
      // Limit the number of results and choose fields to display
      apiUrl += `&per_page=10&fields=school.name,school.city,school.state,school.school_url`;
      
      // Show a loading message
      document.getElementById("results").innerHTML = "Loading...";
      
      // Fetch data from the API
      fetch(apiUrl)
        .then(response => response.json())
        .then(data => {
          if (data.results && data.results.length > 0) {
            let html = "";
            data.results.forEach(college => {
              html += `<div class="result">
                        <h3>${college["school.name"]}</h3>
                        <p>${college["school.city"]}, ${college["school.state"]}</p>`;
              if (college["school.school_url"]) {
                // Ensure the URL starts with "http://" or "https://"
                let url = college["school.school_url"];
                if (!url.startsWith("http")) {
                  url = "http://" + url;
                }
                html += `<p><a href="${url}" target="_blank">Visit Website</a></p>`;
              }
              html += `</div>`;
            });
            document.getElementById("results").innerHTML = html;
          } else {
            document.getElementById("results").innerHTML = "No results found.";
          }
        })
        .catch(error => {
          console.error("Error fetching college data:", error);
          document.getElementById("results").innerHTML = "An error occurred while fetching data.";
        });
    });
  </script>

</body>
</html>
