// $.ajax({
//   type: "POST",
//   url: "populateDB.py"
// }).done(function( o ) {
//    console.log('Executed "populateDB.py');
// });

// Initialize Parse to push to db.
Parse.initialize("jLPaR5dxLjHRT8soPkn2jHkNEqRhpKHMuLDljWlx", "ZuGX6w5OWm0k2qUY6DLMdz7xBvzu3ONzbD4YgGuy");
var Course = Parse.Object.extend("Course");


$(document).ready(function() {
	$('body').load('course_codes.out', function() {
		var courses = $('body').html().split('\n');
		
		courses.forEach(function(line) {
			var course = new Course();
			var attr = line.split(',');
			course.set('subject', attr[0]);
			course.set('code', attr[1]);
			course.set('building', attr[2]);

			course.save(null,
						{success: function(res) {
							console.log(res);
						}});
		});
	});
});