using System;
using Bussiness;
using Game.Server.GameObjects;

internal class Class12
{
	private static bool bool_0;

	public static int int_0;

	public static void smethod_0(bool bool_1)
	{
		bool_0 = bool_1;
	}

	public static bool smethod_1()
	{
		return bool_0;
	}

	public static double pUjigatxrH(int int_1)
	{
		if (!bool_0)
		{
			return 1.0;
		}
		if (0 <= int_1 && int_1 <= 240)
		{
			return 1.0;
		}
		if (240 < int_1 && int_1 <= 300)
		{
			return 0.5;
		}
		return 0.0;
	}

	public static int smethod_2(GamePlayer gamePlayer_0)
	{
		int ıD = gamePlayer_0.PlayerCharacter.ID;
		bool flag = true;
		gamePlayer_0.Boolean_0 = false;
		gamePlayer_0.IsMinor = true;
		using (ProduceBussiness produceBussiness = new ProduceBussiness())
		{
			string aSSInfoSingle = produceBussiness.GetASSInfoSingle(ıD);
			if (aSSInfoSingle != "")
			{
				gamePlayer_0.Boolean_0 = true;
				flag = false;
				int num = Convert.ToInt32(aSSInfoSingle.Substring(6, 4));
				int value = Convert.ToInt32(aSSInfoSingle.Substring(10, 2));
				if (DateTime.Now.Year.CompareTo(num + 18) > 0 || (DateTime.Now.Year.CompareTo(num + 18) == 0 && DateTime.Now.Month.CompareTo(value) >= 0))
				{
					gamePlayer_0.IsMinor = false;
				}
			}
		}
		if (flag && gamePlayer_0.PlayerCharacter.IsFirst != 0 && gamePlayer_0.PlayerCharacter.DayLoginCount < 1 && bool_0)
		{
			gamePlayer_0.Out.SendAASState(flag);
		}
		if (gamePlayer_0.IsMinor || (!gamePlayer_0.Boolean_0 && bool_0))
		{
			gamePlayer_0.Out.SendAASControl(bool_0, gamePlayer_0.Boolean_0, gamePlayer_0.IsMinor);
		}
		return 0;
	}

	static Class12()
	{
		int_0 = 0;
	}
}
