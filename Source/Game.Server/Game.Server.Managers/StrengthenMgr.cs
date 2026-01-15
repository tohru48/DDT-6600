using System;
using System.Collections.Generic;
using System.Reflection;
using Bussiness;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.Managers
{
	public class StrengthenMgr
	{
		private static readonly ILog ilog_0;

		private static Dictionary<int, StrengthenInfo> dictionary_0;

		private static Dictionary<int, StrengthenInfo> dictionary_1;

		private static Dictionary<int, StrengthenGoodsInfo> dictionary_2;

		private static Dictionary<int, StrengThenExpInfo> dictionary_3;

		private static ThreadSafeRandom threadSafeRandom_0;

		public static readonly int NECKLACE_MAX_LEVEL;

		public static bool ReLoad()
		{
			try
			{
				Dictionary<int, StrengthenInfo> strengthen = new Dictionary<int, StrengthenInfo>();
				Dictionary<int, StrengthenInfo> refineryStrengthen = new Dictionary<int, StrengthenInfo>();
				Dictionary<int, StrengThenExpInfo> strengthenExp = new Dictionary<int, StrengThenExpInfo>();
				Dictionary<int, StrengthenGoodsInfo> strengthensGoods = new Dictionary<int, StrengthenGoodsInfo>();
				if (smethod_0(strengthen, refineryStrengthen, strengthenExp, strengthensGoods))
				{
					try
					{
						dictionary_0 = strengthen;
						dictionary_1 = refineryStrengthen;
						dictionary_3 = strengthenExp;
						dictionary_2 = strengthensGoods;
						return true;
					}
					catch
					{
					}
				}
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("StrengthenMgr", exception);
				}
			}
			return false;
		}

		public static bool Init()
		{
			try
			{
				dictionary_0 = new Dictionary<int, StrengthenInfo>();
				dictionary_1 = new Dictionary<int, StrengthenInfo>();
				dictionary_2 = new Dictionary<int, StrengthenGoodsInfo>();
				dictionary_3 = new Dictionary<int, StrengThenExpInfo>();
				threadSafeRandom_0 = new ThreadSafeRandom();
				return smethod_0(dictionary_0, dictionary_1, dictionary_3, dictionary_2);
			}
			catch (Exception exception)
			{
				if (ilog_0.IsErrorEnabled)
				{
					ilog_0.Error("StrengthenMgr", exception);
				}
				return false;
			}
		}

		private static bool smethod_0(Dictionary<int, StrengthenInfo> strengthen, Dictionary<int, StrengthenInfo> RefineryStrengthen, Dictionary<int, StrengThenExpInfo> StrengthenExp, Dictionary<int, StrengthenGoodsInfo> StrengthensGoods)
		{
			using (ProduceBussiness produceBussiness = new ProduceBussiness())
			{
				StrengthenInfo[] allStrengthen = produceBussiness.GetAllStrengthen();
				StrengthenInfo[] allRefineryStrengthen = produceBussiness.GetAllRefineryStrengthen();
				StrengThenExpInfo[] allStrengThenExp = produceBussiness.GetAllStrengThenExp();
				StrengthenGoodsInfo[] allStrengthenGoodsInfo = produceBussiness.GetAllStrengthenGoodsInfo();
				StrengthenInfo[] array = allStrengthen;
				foreach (StrengthenInfo strengthenInfo in array)
				{
					if (!strengthen.ContainsKey(strengthenInfo.StrengthenLevel))
					{
						strengthen.Add(strengthenInfo.StrengthenLevel, strengthenInfo);
					}
				}
				StrengthenInfo[] array2 = allRefineryStrengthen;
				foreach (StrengthenInfo strengthenInfo2 in array2)
				{
					if (!RefineryStrengthen.ContainsKey(strengthenInfo2.StrengthenLevel))
					{
						RefineryStrengthen.Add(strengthenInfo2.StrengthenLevel, strengthenInfo2);
					}
				}
				StrengThenExpInfo[] array3 = allStrengThenExp;
				foreach (StrengThenExpInfo strengThenExpInfo in array3)
				{
					if (!StrengthenExp.ContainsKey(strengThenExpInfo.Level))
					{
						StrengthenExp.Add(strengThenExpInfo.Level, strengThenExpInfo);
					}
				}
				StrengthenGoodsInfo[] array4 = allStrengthenGoodsInfo;
				foreach (StrengthenGoodsInfo strengthenGoodsInfo in array4)
				{
					if (!StrengthensGoods.ContainsKey(strengthenGoodsInfo.ID))
					{
						StrengthensGoods.Add(strengthenGoodsInfo.ID, strengthenGoodsInfo);
					}
				}
			}
			return true;
		}

		public static StrengThenExpInfo FindStrengthenExpInfo(int level)
		{
			if (dictionary_3.ContainsKey(level))
			{
				return dictionary_3[level];
			}
			return null;
		}

		public static bool canUpLv(int exp, int level)
		{
			StrengThenExpInfo strengThenExpInfo = FindStrengthenExpInfo(level + 1);
			return strengThenExpInfo != null && exp >= strengThenExpInfo.Exp;
		}

		public static int getNeedExp(int Exp, int level)
		{
			StrengThenExpInfo strengThenExpInfo = FindStrengthenExpInfo(level + 1);
			if (strengThenExpInfo == null)
			{
				return 0;
			}
			return strengThenExpInfo.Exp - Exp;
		}

		public static int GetNecklaceExpAdd(int exp, int currentPlus)
		{
			int necklaceLevelByGP = GetNecklaceLevelByGP(exp);
			return FindStrengthenExpInfo(necklaceLevelByGP)?.NecklaceStrengthPlus ?? currentPlus;
		}

		public static int GetNecklaceLevelByGP(int exp)
		{
			for (int num = NECKLACE_MAX_LEVEL; num > -1; num--)
			{
				if (dictionary_3[num].NecklaceStrengthExp <= exp)
				{
					return num;
				}
			}
			return 1;
		}

		public static int GetNecklaceMaxExp()
		{
			return FindStrengthenExpInfo(NECKLACE_MAX_LEVEL)?.NecklaceStrengthExp ?? 0;
		}

		public static int GetNecklaceMaxPlus(int lv)
		{
			return FindStrengthenExpInfo(lv)?.NecklaceStrengthPlus ?? 0;
		}

		public static StrengthenInfo FindStrengthenInfo(int level)
		{
			if (dictionary_0.ContainsKey(level))
			{
				return dictionary_0[level];
			}
			return null;
		}

		public static StrengthenInfo FindRefineryStrengthenInfo(int level)
		{
			if (dictionary_1.ContainsKey(level))
			{
				return dictionary_1[level];
			}
			return null;
		}

		public static StrengthenGoodsInfo FindStrengthenGoodsInfo(int level, int templateId)
		{
			foreach (StrengthenGoodsInfo value in dictionary_2.Values)
			{
				if (value.Level == level && templateId == value.CurrentEquip)
				{
					return value;
				}
			}
			return null;
		}

		public static StrengthenGoodsInfo FindTransferInfo(int level, int templateId)
		{
			foreach (StrengthenGoodsInfo value in dictionary_2.Values)
			{
				if (value.Level == level && templateId == value.CurrentEquip)
				{
					return value;
				}
			}
			return null;
		}

		public static StrengthenGoodsInfo FindTransferInfo(int templateId)
		{
			foreach (StrengthenGoodsInfo value in dictionary_2.Values)
			{
				if (templateId != value.GainEquip && templateId != value.CurrentEquip)
				{
					continue;
				}
				return value;
			}
			return null;
		}

		public static void InheritProperty(ItemInfo Item, ref ItemInfo item)
		{
			if (Item.Hole1 >= 0)
			{
				item.Hole1 = Item.Hole1;
			}
			if (Item.Hole2 >= 0)
			{
				item.Hole2 = Item.Hole2;
			}
			if (Item.Hole3 >= 0)
			{
				item.Hole3 = Item.Hole3;
			}
			if (Item.Hole4 >= 0)
			{
				item.Hole4 = Item.Hole4;
			}
			if (Item.Hole5 >= 0)
			{
				item.Hole5 = Item.Hole5;
			}
			if (Item.Hole6 >= 0)
			{
				item.Hole6 = Item.Hole6;
			}
			item.AttackCompose = Item.AttackCompose;
			item.DefendCompose = Item.DefendCompose;
			item.LuckCompose = Item.LuckCompose;
			item.AgilityCompose = Item.AgilityCompose;
			item.IsBinds = Item.IsBinds;
			item.ValidDate = Item.ValidDate;
		}

		public static void InheritTransferProperty(ref ItemInfo itemZero, ref ItemInfo itemOne, bool tranHole, bool tranHoleFivSix)
		{
			int hole = itemZero.Hole1;
			int hole2 = itemZero.Hole2;
			int hole3 = itemZero.Hole3;
			int hole4 = itemZero.Hole4;
			int hole5 = itemZero.Hole5;
			int hole6 = itemZero.Hole6;
			int hole5Exp = itemZero.Hole5Exp;
			int ınt32_ = itemZero.Int32_0;
			int hole6Exp = itemZero.Hole6Exp;
			int ınt32_2 = itemZero.Int32_1;
			int attackCompose = itemZero.AttackCompose;
			int defendCompose = itemZero.DefendCompose;
			int agilityCompose = itemZero.AgilityCompose;
			int luckCompose = itemZero.LuckCompose;
			int strengthenLevel = itemZero.StrengthenLevel;
			int strengthenExp = itemZero.StrengthenExp;
			bool ısGold = itemZero.IsGold;
			int goldValidDate = itemZero.goldValidDate;
			DateTime goldBeginTime = itemZero.goldBeginTime;
			string latentEnergyCurStr = itemZero.latentEnergyCurStr;
			string latentEnergyNewStr = itemZero.latentEnergyNewStr;
			DateTime latentEnergyEndTime = itemZero.latentEnergyEndTime;
			int bless = itemOne.Bless;
			DateTime advanceDate = itemOne.AdvanceDate;
			bool avatarActivity = itemOne.AvatarActivity;
			bool goodsLock = itemOne.goodsLock;
			int magicAttack = itemOne.MagicAttack;
			int magicDefence = itemOne.MagicDefence;
			int hole7 = itemOne.Hole1;
			int hole8 = itemOne.Hole2;
			int hole9 = itemOne.Hole3;
			int hole10 = itemOne.Hole4;
			int hole11 = itemOne.Hole5;
			int hole12 = itemOne.Hole6;
			int hole5Exp2 = itemOne.Hole5Exp;
			int ınt32_3 = itemOne.Int32_0;
			int hole6Exp2 = itemOne.Hole6Exp;
			int ınt32_4 = itemOne.Int32_1;
			int attackCompose2 = itemOne.AttackCompose;
			int defendCompose2 = itemOne.DefendCompose;
			int agilityCompose2 = itemOne.AgilityCompose;
			int luckCompose2 = itemOne.LuckCompose;
			int strengthenLevel2 = itemOne.StrengthenLevel;
			int strengthenExp2 = itemOne.StrengthenExp;
			bool ısGold2 = itemOne.IsGold;
			int goldValidDate2 = itemOne.goldValidDate;
			DateTime goldBeginTime2 = itemOne.goldBeginTime;
			string latentEnergyCurStr2 = itemOne.latentEnergyCurStr;
			string latentEnergyNewStr2 = itemOne.latentEnergyNewStr;
			DateTime latentEnergyEndTime2 = itemOne.latentEnergyEndTime;
			int bless2 = itemOne.Bless;
			DateTime advanceDate2 = itemOne.AdvanceDate;
			bool avatarActivity2 = itemOne.AvatarActivity;
			bool goodsLock2 = itemOne.goodsLock;
			int magicAttack2 = itemOne.MagicAttack;
			int magicDefence2 = itemOne.MagicDefence;
			if (tranHole)
			{
				itemOne.Hole1 = hole;
				itemZero.Hole1 = hole7;
				itemOne.Hole2 = hole2;
				itemZero.Hole2 = hole8;
				itemOne.Hole3 = hole3;
				itemZero.Hole3 = hole9;
				itemOne.Hole4 = hole4;
				itemZero.Hole4 = hole10;
			}
			if (tranHoleFivSix)
			{
				itemOne.Hole5 = hole5;
				itemZero.Hole5 = hole11;
				itemOne.Hole6 = hole6;
				itemZero.Hole6 = hole12;
			}
			itemOne.Hole5Exp = hole5Exp;
			itemZero.Hole5Exp = hole5Exp2;
			itemOne.Int32_0 = ınt32_;
			itemZero.Int32_0 = ınt32_3;
			itemOne.Hole6Exp = hole6Exp;
			itemZero.Hole6Exp = hole6Exp2;
			itemOne.Int32_1 = ınt32_2;
			itemZero.Int32_1 = ınt32_4;
			itemZero.StrengthenLevel = strengthenLevel2;
			itemOne.StrengthenLevel = strengthenLevel;
			itemZero.StrengthenExp = strengthenExp2;
			itemOne.StrengthenExp = strengthenExp;
			itemZero.AttackCompose = attackCompose2;
			itemOne.AttackCompose = attackCompose;
			itemZero.DefendCompose = defendCompose2;
			itemOne.DefendCompose = defendCompose;
			itemZero.LuckCompose = luckCompose2;
			itemOne.LuckCompose = luckCompose;
			itemZero.AgilityCompose = agilityCompose2;
			itemOne.AgilityCompose = agilityCompose;
			if (itemZero.IsBinds || itemOne.IsBinds)
			{
				itemOne.IsBinds = true;
				itemZero.IsBinds = true;
			}
			itemZero.goldBeginTime = goldBeginTime2;
			itemOne.goldBeginTime = goldBeginTime;
			itemZero.goldValidDate = goldValidDate2;
			itemOne.goldValidDate = goldValidDate;
			itemZero.latentEnergyCurStr = latentEnergyCurStr2;
			itemOne.latentEnergyCurStr = latentEnergyCurStr;
			itemZero.latentEnergyNewStr = latentEnergyNewStr2;
			itemOne.latentEnergyNewStr = latentEnergyNewStr;
			itemZero.latentEnergyEndTime = latentEnergyEndTime2;
			itemOne.latentEnergyEndTime = latentEnergyEndTime;
			itemZero.Bless = bless2;
			itemOne.Bless = bless;
			itemZero.AdvanceDate = advanceDate2;
			itemOne.AdvanceDate = advanceDate;
			itemZero.AvatarActivity = avatarActivity2;
			itemOne.AvatarActivity = avatarActivity;
			itemZero.goodsLock = goodsLock2;
			itemOne.goodsLock = goodsLock;
			itemZero.MagicAttack = magicAttack2;
			itemOne.MagicAttack = magicAttack;
			itemZero.MagicDefence = magicDefence2;
			itemOne.MagicDefence = magicDefence;
		}

		static StrengthenMgr()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
			NECKLACE_MAX_LEVEL = 12;
		}
	}
}
