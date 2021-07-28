using System.Linq;
using System.Web;
using System.Web.Mvc;
using isRock.LineLoginV21;
using Newtonsoft.Json;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System;
using System.Web.Security;
using System.Net.Mail;

//final

namespace Webproject.Controllers
{
    public class StudentController : Controller
    {
        string LineLogin = "https://54d61a5fb0e8.ngrok.io";         // LineLogin_Callback_url
        string Client_id = "1655812280";                            // LineLogin_Client_id
        string Client_secret = "d3b069e868ece1d5e46937b2bf16ee41";  // LineLogin_Client_secret
        string Bot_Basic_id = "@145ltdwx";                          // LineLogin_Bot_Basic_id
        // GET: Student
        public ActionResult Index()
        {
            return View("Index", "_Layout-Student");
        }
        string constr2 = @"Data Source=(LocalDB)\MSSQLLocalDB;" + "AttachDbFilename=|DataDirectory|BlueAssistDB.mdf;" + "Integrated Security=True";
        string constr = @"Data Source=localhost;Initial Catalog=DepChatBot2;User ID=Wiwi;Password=0919794175;";
        public class Lineget
        {
            public string displayName { get; set; }

            public string userId { get; set; }

            public string pictureUrl { get; set; }

            public string statusMessage { get; set; }
        }
        public ActionResult Login()
        {
            return View();
        }
        [HttpGet]
        public ActionResult Callback()
        {
            //取得返回的code
            var code = Request.QueryString["code"];
            if (code == null)
            {
                ViewBag.access_token = "沒有正確的code...";
                return View("Index", "_Layout-Student");
            }
            //從Code取回toke
            var token = Utility.GetTokenFromCode(code,
                Client_id,  //TODO:請更正為你自己的 client_id
                Client_secret, //TODO:請更正為你自己的 client_secret
                LineLogin+"/Student/Callback");  //LineLogin 位置
            //利用access_token取得用戶資料
            var user = Utility.GetUserProfile(token.access_token);
            //利用id_token取得Claim資料
            var JwtSecurityToken = new System.IdentityModel.Tokens.Jwt.JwtSecurityToken(token.id_token);
            var email = "";
            //如果有email
            if (JwtSecurityToken.Claims.ToList().Find(c => c.Type == "email") != null)
                email = JwtSecurityToken.Claims.First(c => c.Type == "email").Value;
            Lineget get1 = JsonConvert.DeserializeObject<Lineget>(Newtonsoft.Json.JsonConvert.SerializeObject(user));
            Session["Email"] = email;
            Session["userID"] = get1.userId;
            Session["token"] = token.access_token;
            Session["username"] = get1.displayName;
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            string sql1 = string.Format("select COUNT(*) from Student  where Student_userID ='{0}'", get1.userId);
            con1.Open();
            SqlCommand cmd1 = new SqlCommand(sql1, con1);

            int _count = (int)cmd1.ExecuteScalar();
            if (_count == 1)
            {
                con1.Close();
                Debug.WriteLine("有帳號了");
                return View("Index", "_Layout-Student");
            }
            else
            {
                con1.Close();
                return Redirect("~/Student/Create");
            }
        }
        public ActionResult Create()
        {
            ViewBag.name = Session["username"];
            ViewBag.token = Session["token"];
            ViewBag.email = Session["Email"];
            ViewBag.userid = Session["userID"];
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            string sql1 = string.Format("select School_name from School");
            SqlDataAdapter adp = new SqlDataAdapter(sql1, con1);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            return View("Create",ds.Tables[0]);
        }
        [HttpPost]
        public ActionResult Create(string name,string token,string email,string userid,int gender,string birthday,string guardian_name,string guardian_phnumber,
            string teacher,string sclass,string IDNumber ,string LineID,string verification, string SchoolName)
        {
             Debug.WriteLine(verification);
             Debug.WriteLine(SchoolName);
             SqlConnection con1 = new SqlConnection();
             con1.ConnectionString = constr;
             con1.Open();
             string sql1 = string.Format("select Count(*) from Verification Where Verification =N'{0}'", verification);
             SqlCommand cmd = new SqlCommand(sql1, con1);
             if ((int)cmd.ExecuteScalar() == 1)
             {
                 string sql2 = string.Format("select School_Id,Socialworker_Id from Verification Where Verification =N'{0}'", verification);
                 SqlDataAdapter adp = new SqlDataAdapter(sql2, con1);
                 DataSet ds = new DataSet();
                 adp.Fill(ds);
                 foreach (DataRow datarow in ds.Tables[0].Rows)
                 {
                    int Socialworker_id = (int)datarow["Socialworker_Id"];
                    int School_id = (int)datarow["School_Id"];
                    string sql3 = string.Format("Insert into Student (School_id,Student_token,Student_Email,Student_name,Student_gender,Student_birthday,Student_guardian_name,Student_guardian_phnumber,Student_teacher,Student_class," +
                        "Student_IDNumber,Socialworker_id,Student_userID,Counseling,LineId) " + "values('{0}',N'{1}','{2}',N'{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}','{13}','{14}')"
                        , School_id, token, email, name, gender, birthday, guardian_name, guardian_phnumber, teacher, sclass, IDNumber, Socialworker_id, userid, 0, LineID);
                    SqlCommand cmd1 = new SqlCommand(sql3, con1);
                    cmd1.ExecuteNonQuery();
                    con1.Close();
                 }
                 return View("Index", "_Layout-Student");
             }
             else
             {
                 string sql4 = string.Format("Insert into Student(Student_token,Student_Email,Student_name,Student_gender,Student_birthday,Student_userID,Counseling,LineId)" +
                        "values('{0}',N'{1}',N'{2}',N'{3}','{4}','{5}','{6}','{7}')",token, email, name, gender, birthday, userid, 1, LineID);
                 SqlCommand cmd2 = new SqlCommand(sql4, con1);
                 cmd2.ExecuteNonQuery();
                 con1.Close();
                 return View("Index", "_Layout-Student");
             }

            /*con1.Close();
            ViewBag.err = "請重新輸入";
            return Redirect("Create");*/

            /*   string sql1 = string.Format("select School_Id from School Where School_name=N'{0}'", SchoolName);
               con1.Open();
               SqlCommand cmd1 = new SqlCommand(sql1, con1);
               int School_ID = (int)cmd1.ExecuteScalar();


               string sql2 = string.Format("select Socialworker_Id from Socialworker where School_id ='{0}'", School_ID);
               SqlCommand cmd2 = new SqlCommand(sql2, con1);
               int Socailworker_ID = (int)cmd2.ExecuteScalar();*/

            /* string sql3 = string.Format("Insert into Student (School_id,Student_token,Student_Email,Student_name,Student_gender,Student_birthday,Student_guardian_name,Student_guardian_phnumber,Student_teacher,Student_class," +
                 "Student_IDNumber,Socialworker_id,Student_userID,Counseling,LineId) " + "values('{0}',N'{1}','{2}',N'{3}','{4}','{5}','{6}','{7}','{8}','{9}','{10}','{11}','{12}','{13}','{14}')"
                 , School_ID, token, email, name, gender, birthday, guardian_name, guardian_phnumber, teacher, sclass, IDNumber, Socailworker_ID, userid, 0, LineID);
             SqlCommand cmd = new SqlCommand(sql3, con1);
             cmd.ExecuteNonQuery();
             con1.Close();*/
        }
        public ActionResult Record()
        {
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            string sql1 = string.Format("select Student_name from Student Where Student_userID = N'{0}'",Session["userID"]);
            con1.Open();
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            string name = (string)cmd1.ExecuteScalar();
            Debug.WriteLine(name);
            ViewBag.name = name;
            con1.Close();
            return View("Record", "_Layout-Student");
        }
        [HttpPost]
        public ActionResult Record(int AssistClass, string content)
        {
            DateTime time = DateTime.Now;
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            string sql1 = string.Format("select Student_Id,Socialworker_id from Student Where Student_userID  =N'{0}'", Session["userID"]);
            con1.Open();
            SqlDataAdapter adp = new SqlDataAdapter(sql1, con1);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            foreach (DataRow datarow in ds.Tables[0].Rows)
            {
                int Socialworker_id = (int)datarow["Socialworker_id"];
                int Student_id = (int)datarow["Student_Id"];
                string sql3 = string.Format("Insert into Record (AssistClass,Socialworker_id,Student_id,Student_content,Student_requestTime) values('{0}','{1}','{2}','{3}','{4}')", AssistClass, Socialworker_id, Student_id, content, time.ToString("yyyy-MM-dd HH:mm"));
                SqlCommand cmd = new SqlCommand(sql3, con1);
                cmd.ExecuteNonQuery();
                con1.Close();
            }

            Session.Add("checkRecord", "");
            Session["checkRecord"] = "true";

            return View("Index", "_Layout-Student");
        }
        public ActionResult SearchRecord()
        {
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            con1.Open();
            string sql1 = string.Format("select Student_Id from Student Where Student_userID  =N'{0}'", Session["userID"]);
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            int student_id = (int)cmd1.ExecuteScalar();
            //int Student_Id = Convert.ToInt32(Session["userID"]);
            string sql2 = string.Format("select * from Record Right join Socialworker on Record.Socialworker_Id = Socialworker.Socialworker_Id where Student_Id = '{0}'", student_id);
            SqlDataAdapter adp = new SqlDataAdapter(sql2, con1);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            con1.Close();
            return View("SearchRecord", "_Layout-Student", ds.Tables[0]);
        }
        public ActionResult Scale()
        {
            return View("Scale","_Layout-Student");
        }
        [HttpPost]
        public ActionResult Scale(string userid,int q1,int q2,int q3, int q4, int q5, int q6, int q7, int q8, int q9, int q10, int q11, int q12, int q13, int q14, int q15, int q16, int q17, int q18)
        {

            int total = q1 + q2 + q3 + q4 + q5 + q6 + q7 + q8 + q9 + q10 + q11 + q12 + q13 + q14 + q15 + q16 + q17 + q18;
            Debug.WriteLine(total);
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            string sql1 = string.Format("select Student_Id from Student Where Student_userID = '{0}'", Session["userID"]);
            con1.Open();
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            int Student_Id = (int)cmd1.ExecuteScalar();
            //int Student_Id = Convert.ToInt32(Session["userID"]);

            string sql2 = string.Format("Insert into Scale (Student_Id,Scale_Total,RequestTime) values('{0}','{1}','{2}')", Student_Id, total, DateTime.Now.ToString("yyyy-MM-dd HH:mm"));
            SqlCommand cmd2 = new SqlCommand(sql2, con1);
            cmd2.ExecuteNonQuery();

            con1.Close();

            Session.Add("check", "");
            Session["check"] = "true";

            return View("Index", "_Layout-Student");
        }
        public ActionResult SearchScale()
        {
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            con1.Open();
            string sql1 = string.Format("select Student_Id from Student Where Student_userID  =N'{0}'", Session["userID"]);
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            int Student_Id = (int)cmd1.ExecuteScalar();

            string sql3 = string.Format("select Student_name from Student Where Student_userID  =N'{0}'", Session["userID"]);
            SqlCommand cmd2 = new SqlCommand(sql3, con1);
            ViewBag.Student_name = cmd2.ExecuteScalar().ToString();

            //int student_id = (int)cmd1.ExecuteScalar();
            //int Student_Id = Convert.ToInt32(Session["userID"]);
            //string sql2 = string.Format("select * from Scale Right join Student on Scale.Student_Id = Student.Student_Id");
            string sql2 = string.Format("select * from Scale Where Student_Id = N'{0}'", Student_Id.ToString());
            SqlDataAdapter adp = new SqlDataAdapter(sql2, con1);
            DataSet ds = new DataSet();
            adp.Fill(ds);
            con1.Close();
            return View("SearchScale", "_Layout-Student", ds.Tables[0]);
        }
        public ActionResult Feedback()
        {
            return View("Feedback", "_Layout-Student");
        }
        [HttpPost]
        public ActionResult Feedback(int socialworker_id,string userid,int Assist,int q1,int q2,int q3,int q4)
        {
            int qt =( q1 + q2 + q3 + q4)/4;
            int count = (qt >= 2.5) ? 1 : 0;
            SqlConnection con1 = new SqlConnection();
            con1.ConnectionString = constr;
            con1.Open();

            string sql1 = string.Format("select Student_Id from Student Where Student_userID  =N'{0}'", Session["userID"]);
            SqlCommand cmd1 = new SqlCommand(sql1, con1);
            int Student_Id = (int)cmd1.ExecuteScalar();

            try
            {
                string sql_test = string.Format("select Assist from ShortFeedBack Where CaseID  =N'{0}'", Session["cid"]);
                SqlCommand cmd_test = new SqlCommand(sql_test, con1);
                int CaseID = (int)cmd_test.ExecuteScalar();
                return View("alert", "_Layout-Student");
            }
            catch (Exception e)
            {
                string sql2 = string.Format("Insert into ShortFeedBack (Student_Id,Judgment_Score,Socialworker_Id,Assist,CaseID) values('{0}','{1}','{2}','{3}','{4}')", Student_Id, count, socialworker_id, Assist, Session["cid"]);
                SqlCommand cmd2 = new SqlCommand(sql2, con1);
                cmd2.ExecuteNonQuery();
                {
                    string sql3 = string.Format("select Count(*) from ShortFeedback Where Judgment_Score ='{0}' AND Assist='{1}' AND Socialworker_Id='{2}'", 1, 0, 1);
                    SqlCommand cmd3 = new SqlCommand(sql3, con1);
                    int score = (int)cmd3.ExecuteScalar();

                    string sql4 = string.Format("select Count(*) from ShortFeedback Where  Socialworker_Id='{0}'", 1);
                    SqlCommand cmd4 = new SqlCommand(sql4, con1);
                    int score1 = (int)cmd4.ExecuteScalar();

                    double tf = score / score1;

                    string sql5 = string.Format("select Count(*) from ShortFeedback Where Judgment_Score ='{0}' AND Assist='{1}'", 1, 0, 1);
                    SqlCommand cmd5 = new SqlCommand(sql5, con1);
                    int score2 = (int)cmd5.ExecuteScalar();

                    string sql6 = string.Format("select Count(*) from ShortFeedback");
                    SqlCommand cmd6 = new SqlCommand(sql6, con1);
                    int score3 = (int)cmd6.ExecuteScalar();

                    double idf = score2 / score3;

                    double tfidf = tf * Math.Log(idf);
                    /*
                        * Judgment_Score  0代表小於2,1代表大於2
                        * Assist, 0代表感情,1代表工作,2代表新生
                        */
                }
                //return View("Index", "_Layout-Student");

                con1.Close();
                Session.Add("shortbee", "");
                Session["shortbee"] = "True";
                //return View("alert", "_Layout-Student");
                return Redirect("http://line.me/ti/p/"+Bot_Basic_id);
            };


            //return View("Index", "_Layout-Student");
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

        public void sendGmail(string emailID)
        {
            //https://www.google.com/settings/security/lesssecureapps
            MailMessage mail = new MailMessage();
            //前面是發信email後面是顯示的名稱
            mail.From = new MailAddress("s32154104@gmail.com", "信件名稱");

            //收信者email
            mail.To.Add(Request.QueryString["email"]);

            //設定優先權
            mail.Priority = MailPriority.Normal;

            //標題
            mail.Subject = "社工您好，請查收新CASE信件";

            //內容
            mail.Body = "您有新的CASE，LINE ID為:" + Request.QueryString["lineID"];

            //內容使用html
            mail.IsBodyHtml = true;

            //設定gmail的smtp (這是google的)
            SmtpClient MySmtp = new SmtpClient("smtp.gmail.com", 587);

            //您在gmail的帳號密碼
            MySmtp.Credentials = new System.Net.NetworkCredential("weiu30795344@gmail.com", "qgropjpkiertsfdi");

            //開啟ssl
            MySmtp.EnableSsl = true;

            //發送郵件
            MySmtp.Send(mail);

            //放掉宣告出來的MySmtp
            MySmtp = null;

            //放掉宣告出來的mail
            mail.Dispose();

            Response.Redirect("Index");
        }
    }
}