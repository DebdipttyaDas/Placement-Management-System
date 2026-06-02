import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateCompanyProfileServlet")
public class UpdateCompanyProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // show current profile (stored in session). If none, set defaults.
        HttpSession session = req.getSession();
        if (session.getAttribute("companyName") == null) {
            session.setAttribute("companyName", "Google");
            session.setAttribute("industry", "Technology & Innovation");
            session.setAttribute("companyType", "MNC");
            session.setAttribute("companyEmail", "recruiting@google.com");
            session.setAttribute("companyPhone", "+1-650-253-0000");
            session.setAttribute("companyWebsite", "https://www.google.com");
            session.setAttribute("companyLinkedin", "https://linkedin.com/company/google");
            session.setAttribute("companyAddress", "1600 Amphitheatre Pkwy");
            session.setAttribute("city", "Mountain View");
            session.setAttribute("state", "California");
            session.setAttribute("country", "USA");
            session.setAttribute("pincode", "94043");
            session.setAttribute("cin", "L72200MH2000PLC128333");
            session.setAttribute("registrationNum", "REG123456");
            session.setAttribute("licenseNum", "LIC789012");
            session.setAttribute("gstNum", "06AAAAB1234C1Z0");
        }
        resp.sendRedirect(req.getContextPath() + "/CompanyProfile.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        HttpSession session = req.getSession();

        // Read parameters from a form. All are optional; if present, update session attributes.
        String name = trimToNull(req.getParameter("companyName"));
        String industry = trimToNull(req.getParameter("industry"));
        String companyType = trimToNull(req.getParameter("companyType"));
        String companyCode = trimToNull(req.getParameter("companyCode"));
        String password = trimToNull(req.getParameter("password"));

        String companyPhone = trimToNull(req.getParameter("companyPhone"));
        String companyEmail = trimToNull(req.getParameter("companyEmail"));
        String companyWebsite = trimToNull(req.getParameter("companyWebsite"));
        String companyLinkedin = trimToNull(req.getParameter("companyLinkedin"));

        String companyAddress = trimToNull(req.getParameter("companyAddress"));
        String city = trimToNull(req.getParameter("city"));
        String state = trimToNull(req.getParameter("state"));
        String country = trimToNull(req.getParameter("country"));
        String pincode = trimToNull(req.getParameter("pincode"));

        String cin = trimToNull(req.getParameter("cin"));
        String registrationNum = trimToNull(req.getParameter("registrationNum"));
        String licenseNum = trimToNull(req.getParameter("licenseNum"));
        String gstNum = trimToNull(req.getParameter("gstNum"));

        if (name != null) session.setAttribute("companyName", name);
        if (industry != null) session.setAttribute("industry", industry);
        if (companyType != null) session.setAttribute("companyType", companyType);
        if (companyCode != null) session.setAttribute("companyCode", companyCode);
        if (password != null) session.setAttribute("password", password);
        if (companyPhone != null) session.setAttribute("companyPhone", companyPhone);
        if (companyEmail != null) session.setAttribute("companyEmail", companyEmail);
        if (companyWebsite != null) session.setAttribute("companyWebsite", companyWebsite);
        if (companyLinkedin != null) session.setAttribute("companyLinkedin", companyLinkedin);
        if (companyAddress != null) session.setAttribute("companyAddress", companyAddress);
        if (city != null) session.setAttribute("city", city);
        if (state != null) session.setAttribute("state", state);
        if (country != null) session.setAttribute("country", country);
        if (pincode != null) session.setAttribute("pincode", pincode);
        if (cin != null) session.setAttribute("cin", cin);
        if (registrationNum != null) session.setAttribute("registrationNum", registrationNum);
        if (licenseNum != null) session.setAttribute("licenseNum", licenseNum);
        if (gstNum != null) session.setAttribute("gstNum", gstNum);

        // After update, redirect back to profile page
        resp.sendRedirect(req.getContextPath() + "/CompanyProfile.jsp");
    }

    private String trimToNull(String s) {
        if (s == null) return null;
        s = s.trim();
        return s.isEmpty() ? null : s;
    }
}
