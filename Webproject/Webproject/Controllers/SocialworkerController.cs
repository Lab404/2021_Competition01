using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

namespace Webproject.Controllers
{
    public class SocialworkerController : Controller
    {
        string constr2 = @"Data Source=(LocalDB)\MSSQLLocalDB;" + "AttachDbFilename=|DataDirectory|BlueAssistDB.mdf;" + "Integrated Security=True";
        string constr = @"Data Source=localhost;Initial Catalog=DepChatBot2;User ID=Wiwi;Password=0919794175;";
        // GET: Socialworker
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Create()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Create(string account, string password, string name, int gender, string email, string birthday, string IDnumber, string verification)
        {
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            string sql1 = string.Format("select School_Id from Verification Where Verification = '{0}'", verification);
            con1.Open();

            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            int School_Id = (int)cmd1.ExecuteScalar();

            string sql2 = string.Format("Insert into Socialworker (Socialworker_Email,School_id,Socialworker_name,Socialworker_gender," +
                "Socialworker_birthday,Socialworker_IDnumber,Socialworker_account,Socialworker_password) values('{0}','{1}','{2}','{3}','{4}','{5}','{6}','{7}')",
                email, School_Id, name, gender, birthday, IDnumber, account, password);
            SqlCommand cmd2 = new SqlCommand(sql2, con1);
            cmd2.ExecuteNonQuery();


            con1.Close();
            return View("Login");
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
            string sql1 = string.Format("select Count(*) from Socialworker Where Socialworker_account=N'{0}' AND Socialworker_password=N'{1}'", account, password);
            con1.Open();
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            if ((int)cmd1.ExecuteScalar() == 1)
            {
                Session["account"] = account;
                Session["password"] = password;
                return View("Index", "_Layout-Socialworker");
            }
            return View();

        }
        public ActionResult ShowStudent()
        {
            if (Session["account"] == null)
            {
                Session.Add("account", "");
                Session["account"] = Request.QueryString["acc"];

                Session.Add("password", "");
                Session["password"] = Request.QueryString["pwd"];
            }

            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;

            con1.Open();
            string sql1 = string.Format("select Socialworker_Id from Socialworker Where Socialworker_account=N'{0}' AND Socialworker_password=N'{1}'", Session["account"], Session["password"]);
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            int Socialworker_Id = (int)cmd1.ExecuteScalar();

            string sql2 = string.Format("select * from Student where Socialworker_id = '{0}'", Socialworker_Id);
            SqlDataAdapter adp = new SqlDataAdapter(sql2, con1);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            con1.Close();
            return View("ShowStudent", "_Layout-Socialworker", ds.Tables[0]);

        }
        public ActionResult ShowRecord(int id)
        {
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            con1.Open();
            string sql1 = string.Format("select * from Record where Student_Id = '{0}'", id);
            SqlDataAdapter adp = new SqlDataAdapter(sql1, con1);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            foreach (DataRow datarow in ds.Tables[0].Rows)
            {
                int Student_id = (int)datarow["Student_Id"];
                string sql2 = string.Format("select Student_name from Student Where Student_Id='{0}'", Student_id);
                SqlCommand cmd2 = new SqlCommand(sql2, con1);
                ViewBag.name = (string)cmd2.ExecuteScalar();
            }

            con1.Close();
            return View("ShowRecord", "_Layout-Socialworker", ds.Tables[0]);

        }

        public ActionResult Edit(int id)
        {
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            con1.Open();
            string sql1 = string.Format("select * from Record where Case_Id = '{0}'", id);
            SqlDataAdapter adp = new SqlDataAdapter(sql1, con1);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            foreach (DataRow datarow in ds.Tables[0].Rows)
            {
                int Student_id = (int)datarow["Student_Id"];
                string sql2 = string.Format("select Student_name from Student Where Student_Id='{0}'", Student_id);
                SqlCommand cmd2 = new SqlCommand(sql2, con1);
                ViewBag.name = (string)cmd2.ExecuteScalar();
                ViewBag.centent = (string)datarow["Student_content"];
                ViewBag.Case = (int)datarow["Case_Id"];
            }
            con1.Close();
            return View("Edit", "_Layout-Socialworker", ds.Tables[0]);

        }
        [HttpPost]
        public ActionResult Edit(int id,string Socialworker_centent)
        {
            DateTime time = DateTime.Now;
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            con1.Open();
            string sql1 = string.Format("update Record set Socialworker_content='{0}',Socialworker_requestTime='{1}' where Case_Id ='{2}'", Socialworker_centent, time.ToString("yyyy-MM-dd HH:mm"), id);
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            cmd1.ExecuteNonQuery();
            //return Redirect("~/Socialworker/ShowStudent");


            string sql2 = string.Format("select * from Record where Case_Id = '{0}'", id);
            SqlDataAdapter adp = new SqlDataAdapter(sql2, con1);
            DataSet ds = new DataSet();
            adp.Fill(ds);

            foreach (DataRow datarow in ds.Tables[0].Rows)
            {
                Session.Add("ID", "");
                Session["ID"] = (int)datarow["Student_Id"];

                Session.Add("Socialworker_centent", "");
                Session["Socialworker_centent"] = Socialworker_centent;

                Session.Add("Student_requestTime", "");
                Session["Student_requestTime"] = datarow["Student_requestTime"];

                Session.Add("Socialworker_Id", "");
                Session["Socialworker_Id"] = datarow["Socialworker_Id"];
            }


            return Redirect("~/Socialworker/alert");
        }

        public ActionResult alert()
        {
            return View();
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