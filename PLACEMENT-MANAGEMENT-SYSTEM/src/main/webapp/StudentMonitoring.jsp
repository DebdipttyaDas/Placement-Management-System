<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
 <meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Student Monitoring</title>

<link rel="stylesheet" href="StudentMonitoring.css">

<!-- Font Awesome -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>

<body>

<div class="container">

    <!-- Sidebar -->
    <div class="sidebar">
        <h2>Student Monitoring</h2>
        
        <ul class="menu">
            <li><a href="AdminDashboard.jsp" style="text-decoration: none; color: white;">Dashboard</a></li>
            <li><a href="CompanyMonitoring.jsp" style="text-decoration: none; color: white;">Company Monitoring</a></li>
            <li class="active">Student Monitoring</li>
            <li><a href="#" style="text-decoration: none; color: white;">Notifications</a></li>
        </ul>
    </div>

   
    <!-- Main Content -->

    <div class="main-content">

        <!-- Stats Cards -->

        <div class="stats">

            <div class="card">
                <h5>TOTAL STUDENTS</h5>
                <h2>1,248 <span>+12%</span></h2>
            </div>

            <div class="card blue">
                <h5>PLACEMENT RATE</h5>
                <h2>92%</h2>
                <p>Goal: 95%</p>
            </div>

            <div class="card">
                <h5>PENDING REVIEWS</h5>
                <h2>45 <span style="color:#d97706;">Priority</span></h2>
            </div>

        </div>


        <!-- Header -->

<div class="header">

            <div class="title">
                <h3>
                    Track, Analyze & Improve Student Performance
                </h3>
            </div>
    <div class="filters">

    <input type="text" placeholder="Search students,departments...">

    <select>

        <option selected disabled hidden>ALL DEPARTMENTS</option>

        <option>Computer Science</option>

        <option>BCA</option>

        <option>MCA</option>

        <option>BBA</option>

        <option>MBA</option>

        <option>ECE</option>

        <option>EEE</option>

    </select>

</div>



        <!-- Table -->

       <div class="table-container">
    <table>
        <thead>
            <tr>
                <th>Student Name</th>
                <th>Department</th>
                <th>GPA</th>
                <th>Status</th>
                <th class="text-right">Actions</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td>
                    <div class="student">
                        <div class="student-avatar">MC</div>
                        <div>
                            <h4>Marcus Chen</h4>
                            <p>Senior Year</p>
                        </div>
                    </div>
                </td>
                <td>EEE</td>
                <td><span class="gpa">3.92</span></td>
                <td><span class="status active-status">ACTIVE</span></td>
                <td class="text-right"><i class="fa fa-ellipsis-h action-icon"></i></td>
            </tr>
            <tr>
                <td>
                    <div class="student">
                        <div class="student-avatar">ER</div>
                        <div>
                            <h4>Elena Rodriguez</h4>
                            <p>Junior Year</p>
                        </div>
                    </div>
                </td>
                <td>Computer Science</td>
                <td><span class="gpa">3.75</span></td>
                <td><span class="status pending-status">PENDING</span></td>
                <td class="text-right"><i class="fa fa-ellipsis-h action-icon"></i></td>
            </tr>
            <tr>
                <td>
                    <div class="student">
                        <div class="student-avatar">JV</div>
                        <div>
                            <h4>Julian Vance</h4>
                            <p>Senior Year</p>
                        </div>
                    </div>
                </td>
                <td>BCA</td>
                <td><span class="gpa">3.88</span></td>
                <td><span class="status active-status">ACTIVE</span></td>
                <td class="text-right"><i class="fa fa-ellipsis-h action-icon"></i></td>
            </tr>
            <tr>
                <td>
                    <div class="student">
                        <div class="student-avatar">SJ</div>
                        <div>
                            <h4>Sarah Jenkins</h4>
                            <p>Sophomore</p>
                        </div>
                    </div>
                </td>
                <td>BBA</td>
                <td><span class="gpa">3.61</span></td>
                <td><span class="status pending-status">PENDING</span></td>
                <td class="text-right"><i class="fa fa-ellipsis-h action-icon"></i></td>
            </tr>
        </tbody>
    </table>

    <!-- Footer is now safely outside the table tag, but inside the main container -->
    <div class="table-footer">
        <p>Showing <strong>1-4</strong> of <strong>1,248</strong> students</p>
        <div class="pagination">
            <button class="btn-page" type="button">&lt;</button>
            <button class="btn-page" type="button">&gt;</button>
        </div>
    </div>
   </div>
</div>
</div>
</div>
</body>
</html>