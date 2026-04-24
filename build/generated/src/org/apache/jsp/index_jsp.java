package org.apache.jsp;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.jsp.*;

public final class index_jsp extends org.apache.jasper.runtime.HttpJspBase
    implements org.apache.jasper.runtime.JspSourceDependent {

  private static final JspFactory _jspxFactory = JspFactory.getDefaultFactory();

  private static java.util.List<String> _jspx_dependants;

  static {
    _jspx_dependants = new java.util.ArrayList<String>(2);
    _jspx_dependants.add("/header.jsp");
    _jspx_dependants.add("/footer.jsp");
  }

  private org.glassfish.jsp.api.ResourceInjector _jspx_resourceInjector;

  public java.util.List<String> getDependants() {
    return _jspx_dependants;
  }

  public void _jspService(HttpServletRequest request, HttpServletResponse response)
        throws java.io.IOException, ServletException {

    PageContext pageContext = null;
    HttpSession session = null;
    ServletContext application = null;
    ServletConfig config = null;
    JspWriter out = null;
    Object page = this;
    JspWriter _jspx_out = null;
    PageContext _jspx_page_context = null;

    try {
      response.setContentType("text/html;charset=UTF-8");
      pageContext = _jspxFactory.getPageContext(this, request, response,
      			null, true, 8192, true);
      _jspx_page_context = pageContext;
      application = pageContext.getServletContext();
      config = pageContext.getServletConfig();
      session = pageContext.getSession();
      out = pageContext.getOut();
      _jspx_out = out;
      _jspx_resourceInjector = (org.glassfish.jsp.api.ResourceInjector) application.getAttribute("com.sun.appserv.jsp.resource.injector");

      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<header>\n");
      out.write("  <h1>Cryptographic Key Exchange Authentication Portal</h1>\n");
      out.write("</header>\n");
      out.write("<nav>\n");
      out.write("  <a href=\"index.jsp\">Home</a>\n");
      out.write("  <a href=\"about.jsp\">About</a>\n");
      out.write("  <a href=\"contact.jsp\">Contact</a>\n");
      out.write("  <a href=\"register.jsp\">Register</a>\n");
      out.write("  <a href=\"alogin.jsp\">Admin Login</a>\n");
      out.write("  <a href=\"ulogin.jsp\">User Login</a>\n");
      out.write("</nav>\n");
      out.write("        ");
      out.write("\n");
      out.write("<link rel=\"stylesheet\" type=\"text/css\" href=\"css/style.css\">\n");
      out.write("<br>\n");
      out.write("<div class=\"carousel\">\n");
      out.write("  <img src=\"images/crypto12.jpg\" class=\"active\" />\n");
      out.write("  <img src=\"images/crypto14.jpg\" />\n");
      out.write("  <img src=\"images/crypto13.jpg\" />\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("<div class=\"container\">\n");
      out.write("  <div class=\"card\">\n");
      out.write("    <h2>Welcome to Crpyto! </h2>\n");
      out.write("    <p>This document presents a detailed study of Cryptographic Key Exchange Authentication, a fundamental security mechanism used to securely exchange cryptographic keys between parties over an insecure network. The system ensures confidentiality, integrity, and authentication using cryptographic protocols.</p>\n");
      out.write("  </div>\n");
      out.write("</div>\n");
      out.write("\n");
      out.write("\n");
      out.write("\n");
      out.write("<footer>\n");
      out.write("  <p>&copy; 2026 Crypto. All rights reserved.</p>\n");
      out.write("</footer>\n");
      out.write("\n");
      out.write("<script src=\"js/script.js\"></script>\n");
    } catch (Throwable t) {
      if (!(t instanceof SkipPageException)){
        out = _jspx_out;
        if (out != null && out.getBufferSize() != 0)
          out.clearBuffer();
        if (_jspx_page_context != null) _jspx_page_context.handlePageException(t);
        else throw new ServletException(t);
      }
    } finally {
      _jspxFactory.releasePageContext(_jspx_page_context);
    }
  }
}
