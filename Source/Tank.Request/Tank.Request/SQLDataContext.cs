using System.Configuration;
using System.Data;
using System.Data.Linq;
using System.Data.Linq.Mapping;
using System.Reflection;

namespace Tank.Request
{
	[Database(Name = "Db_Tank")]
	public class SQLDataContext : DataContext
	{
		private static MappingSource mappingSource = new AttributeMappingSource();

		public SQLDataContext()
			: base(ConfigurationManager.ConnectionStrings["Db_TankConnectionString"].ConnectionString, mappingSource)
		{
		}

		public SQLDataContext(string connection)
			: base(connection, mappingSource)
		{
		}

		public SQLDataContext(IDbConnection connection)
			: base(connection, mappingSource)
		{
		}

		public SQLDataContext(string connection, MappingSource mappingSource)
			: base(connection, mappingSource)
		{
		}

		public SQLDataContext(IDbConnection connection, MappingSource mappingSource)
			: base(connection, mappingSource)
		{
		}

		[Function(Name = "dbo.SP_Account_Register")]
		public int SP_Account_Register([Parameter(Name = "UserName", DbType = "VarChar(200)")] string userName, [Parameter(Name = "PassWord", DbType = "VarChar(200)")] string passWord, [Parameter(Name = "NickName", DbType = "VarChar(50)")] string nickName, [Parameter(Name = "Email", DbType = "VarChar(250)")] string email, [Parameter(Name = "Sex", DbType = "Bit")] bool? sex, [Parameter(Name = "Money", DbType = "Int")] int? money, [Parameter(Name = "Gold", DbType = "Int")] int? gold, [Parameter(Name = "GiftToken", DbType = "Int")] int? giftToken, [Parameter(Name = "Salt", DbType = "VarChar(5)")] string salt)
		{
			IExecuteResult executeResult = ExecuteMethodCall(this, (MethodInfo)MethodBase.GetCurrentMethod(), userName, passWord, nickName, email, sex, money, gold, giftToken, salt);
			return (int)executeResult.ReturnValue;
		}
	}
}
