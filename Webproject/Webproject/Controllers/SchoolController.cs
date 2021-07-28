using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Webproject.Controllers
{
    public class SchoolController : Controller
    {
        string constr2 = @"Data Source=(LocalDB)\MSSQLLocalDB;" + "AttachDbFilename=|DataDirectory|BlueAssistDB.mdf;" + "Integrated Security=True";
        string constr = @"Data Source=localhost;Initial Catalog=DepChatBot2;User ID=Wiwi;Password=0919794175;";
        // GET: School
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Login(string account, string password)
        {
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            string sql1 = string.Format("select Count(*) from School Where School_account=N'{0}' AND School_password=N'{1}'", account,password);
            con1.Open();
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            if ((int)cmd1.ExecuteScalar() == 1)
            {
                Session["account"] = account;
                Session["password"] = password;
                return View("Index","_Layout-School");
            }
            return View();
        }
        public ActionResult SocialworkerVerification()
        {
            return View("SocialworkerVerification", "_Layout-School");
        }
        [HttpPost]
        public ActionResult SocialworkerVerification(string verification)
        {
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;

            string sql1 = string.Format("select School_Id from School Where School_account=N'{0}' AND School_password=N'{1}'", Session["account"],Session["password"]);
            con1.Open();
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            int School_Id = (int)cmd1.ExecuteScalar();

            string sql2 = string.Format("Insert into Verification ( School_Id,Verification) values('{0}','{1}')", School_Id, verification);
            SqlCommand cmd2 = new SqlCommand(sql2, con1);
            cmd2.ExecuteNonQuery();
            con1.Close();

            ViewBag.verification = verification;
            return View();
        }
        public ActionResult StudentVerification()
        {
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            string sql1 = string.Format("select School_Id from School Where School_account=N'{0}' AND School_password=N'{1}'", Session["account"], Session["password"]);
            con1.Open();
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            int School_Id = (int)cmd1.ExecuteScalar();
            string sql2 = string.Format("select Socialworker_name,Socialworker_account from Socialworker where School_id={0}",School_Id);
            SqlDataAdapter adp = new SqlDataAdapter(sql2, con1);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            con1.Close();
            return View("StudentVerification", "_Layout-School", ds.Tables[0]);
        }
        [HttpPost]
        public ActionResult StudentVerification(string socialworker, string verification)
        {
            string[] s = socialworker.Split(',');
           
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;

            string sql1 = string.Format("select Socialworker_Id from Socialworker Where Socialworker_account=N'{0}' ", s[1]);
            con1.Open();
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            int Socialworker_Id = (int)cmd1.ExecuteScalar();


            string sql2 = string.Format("select School_Id from School Where School_account=N'{0}' AND School_password=N'{1}'", Session["account"], Session["password"]);
            SqlCommand cmd2 = new SqlCommand(sql2, con1);
            int School_Id = (int)cmd2.ExecuteScalar();

            string sql3 = string.Format("Insert into Verification ( School_Id,Socialworker_Id,Verification) values('{0}','{1}','{2}')", School_Id, Socialworker_Id, verification);
            SqlCommand cmd3 = new SqlCommand(sql3, con1);
            cmd3.ExecuteNonQuery();
            con1.Close();

            return Redirect("SearchVerification");
        }
        public ActionResult SearchVerification()
        {
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            string sql1 = string.Format("select School_Id from School Where School_account=N'{0}' AND School_password=N'{1}'", Session["account"], Session["password"]);
            con1.Open();
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            int School_Id = (int)cmd1.ExecuteScalar();
            string sql2 = string.Format("select * from Verification right join Socialworker on Verification.Socialworker_Id = Socialworker.Socialworker_Id where Verification.School_id={0}", School_Id);
            SqlDataAdapter adp = new SqlDataAdapter(sql2, con1);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            con1.Close();
            return View("SearchVerification", "_Layout-School", ds.Tables[0]);
        }
        public ActionResult SocialworkerManagement()
        {
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            con1.Open();
            string sql1 = string.Format("select School_Id from School Where School_account=N'{0}' AND School_password=N'{1}'", Session["account"], Session["password"]);
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            int School_Id = (int)cmd1.ExecuteScalar();

            string sql2 = string.Format("select * from Socialworker where School_id = '{0}'", School_Id);
            SqlDataAdapter adp = new SqlDataAdapter(sql2, con1);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            con1.Close();
            return View("SocialworkerManagement", "_Layout-School", ds.Tables[0]);
        }
        public ActionResult ShowStudent(int id) {
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            string sql1 = string.Format("select * from Student where Socialworker_id = '{0}'", id);
            SqlDataAdapter adp = new SqlDataAdapter(sql1, con1);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            con1.Close();
            return View("ShowStudent", "_Layout-School", ds.Tables[0]);
        }
        public ActionResult Logout()
        {
            FormsAuthentication.SignOut();
            Session.RemoveAll();
            HttpCookie cookie1 = new HttpCookie(FormsAuthentication.FormsCookieName, "");
            cookie1.Expires = DateTime.Now.AddYears(-1);
            Response.Cookies.Add(cookie1);
            HttpCookie cookie2 = new HttpCookie("ASP.NET_SessionId", "");
            cookie2.Expires = DateTime.Now.AddYears(-1);
            Response.Cookies.Add(cookie2);
            return RedirectToAction("Index", "Home");
        }
    }
}