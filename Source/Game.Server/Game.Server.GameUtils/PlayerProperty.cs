using System.Collections.Generic;
using System.Reflection;
using Game.Server.GameObjects;
using log4net;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class PlayerProperty
	{
		private static readonly ILog ilog_0;

		protected GamePlayer m_player;

		private Dictionary<string, Dictionary<string, int>> dictionary_0;

		private Dictionary<string, Dictionary<string, int>> dictionary_1;

		protected int m_loading;

		protected int m_totalDamage;

		protected int m_totalArmor;

		public GamePlayer Player => m_player;

		public Dictionary<string, Dictionary<string, int>> Current
		{
			get
			{
				return dictionary_0;
			}
			set
			{
				dictionary_0 = value;
			}
		}

		public Dictionary<string, Dictionary<string, int>> OtherPlayerProperty
		{
			get
			{
				return dictionary_0;
			}
			set
			{
				dictionary_0 = value;
			}
		}

		public int Loading
		{
			get
			{
				return m_loading;
			}
			set
			{
				m_loading = value;
			}
		}

		public int totalDamage
		{
			get
			{
				return m_totalDamage;
			}
			set
			{
				m_totalDamage = value;
			}
		}

		public int totalArmor
		{
			get
			{
				return m_totalArmor;
			}
			set
			{
				m_totalArmor = value;
			}
		}

		public PlayerProperty(GamePlayer player)
		{
			m_player = player;
			dictionary_0 = new Dictionary<string, Dictionary<string, int>>();
			dictionary_1 = new Dictionary<string, Dictionary<string, int>>();
			m_loading = 0;
			m_totalDamage = 0;
			m_totalArmor = 0;
			CreateProp(isSelf: true, "Texp", 0, 0, 0, 0, 0);
			CreateProp(isSelf: true, "Card", 0, 0, 0, 0, 0);
			CreateProp(isSelf: true, "Pet", 0, 0, 0, 0, 0);
			CreateProp(isSelf: true, "Suit", 0, 0, 0, 0, 0);
			CreateProp(isSelf: true, "Gem", 0, 0, 0, 0, 0);
			CreateProp(isSelf: true, "Bead", 0, 0, 0, 0, 0);
			CreateProp(isSelf: true, "Avatar", 0, 0, 0, 0, 0);
			CreateProp(isSelf: true, "MagicStone", 0, 0, 0, 0, 0);
			CreateProp(isSelf: true, "Horse", 0, 0, 0, 0, 0);
			CreateProp(isSelf: true, "HorsePicCherish", 0, 0, 0, 0, 0);
			CreateProp(isSelf: true, "Enchant", 0, 0, 0, 0, 0);
			CreateBaseProp(isSelf: true);
			CreateProp(isSelf: false, "Texp", 0, 0, 0, 0, 0);
			CreateProp(isSelf: false, "Card", 0, 0, 0, 0, 0);
			CreateProp(isSelf: false, "Pet", 0, 0, 0, 0, 0);
			CreateProp(isSelf: true, "Suit", 0, 0, 0, 0, 0);
			CreateProp(isSelf: false, "Gem", 0, 0, 0, 0, 0);
			CreateProp(isSelf: false, "Bead", 0, 0, 0, 0, 0);
			CreateProp(isSelf: false, "Avatar", 0, 0, 0, 0, 0);
			CreateProp(isSelf: false, "MagicStone", 0, 0, 0, 0, 0);
			CreateProp(isSelf: false, "Horse", 0, 0, 0, 0, 0);
			CreateProp(isSelf: false, "HorsePicCherish", 0, 0, 0, 0, 0);
			CreateProp(isSelf: false, "Enchant", 0, 0, 0, 0, 0);
			CreateBaseProp(isSelf: false);
		}

		public void AddProp(string key, Dictionary<string, int> propAdd)
		{
			if (!dictionary_0.ContainsKey(key))
			{
				dictionary_0.Add(key, propAdd);
			}
			else
			{
				dictionary_0[key] = propAdd;
			}
		}

		public void AddOtherProp(string key, Dictionary<string, int> propAdd)
		{
			if (!dictionary_0.ContainsKey(key))
			{
				dictionary_1.Add(key, propAdd);
			}
			else
			{
				dictionary_1[key] = propAdd;
			}
		}

		public void ViewCurrent()
		{
			if (m_player.ShowPP)
			{
				m_player.Out.SendUpdatePlayerProperty(m_player.PlayerCharacter, this);
			}
		}

		public void ViewOther(PlayerInfo player)
		{
			m_player.Out.SendUpdatePlayerProperty(player, this);
		}

		public void CreateBaseProp(bool isSelf)
		{
			Dictionary<string, int> dictionary = new Dictionary<string, int>();
			dictionary.Add("MagicStone", 0);
			dictionary.Add("Horse", 0);
			dictionary.Add("HorsePicCherish", 0);
			dictionary.Add("Enchant", 0);
			dictionary.Add("Suit", 0);
			Dictionary<string, int> dictionary2 = new Dictionary<string, int>();
			dictionary2.Add("MagicStone", 0);
			dictionary2.Add("Horse", 0);
			dictionary2.Add("HorsePicCherish", 0);
			dictionary2.Add("Enchant", 0);
			dictionary2.Add("Suit", 0);
			Dictionary<string, int> dictionary3 = new Dictionary<string, int>();
			dictionary3.Add("Bead", 0);
			dictionary3.Add("Suit", 0);
			dictionary3.Add("Avatar", 0);
			dictionary3.Add("Horse", 0);
			dictionary3.Add("HorsePicCherish", 0);
			Dictionary<string, int> dictionary4 = new Dictionary<string, int>();
			dictionary4.Add("Bead", 0);
			dictionary4.Add("Suit", 0);
			dictionary4.Add("Avatar", 0);
			dictionary4.Add("Horse", 0);
			dictionary4.Add("HorsePicCherish", 0);
			dictionary4.Add("Pet", 0);
			if (isSelf)
			{
				AddProp("Damage", dictionary3);
				AddProp("Armor", dictionary4);
				AddProp("MagicAttack", dictionary);
				AddProp("MagicDefence", dictionary);
			}
			else
			{
				AddOtherProp("Damage", dictionary3);
				AddOtherProp("Armor", dictionary4);
				AddOtherProp("MagicAttack", dictionary);
				AddProp("MagicDefence", dictionary);
			}
		}

		public void UpadateBaseProp(bool isSelf, string mainKey, string subKey, double value)
		{
			if (isSelf)
			{
				if (dictionary_0.ContainsKey(mainKey) && dictionary_0[mainKey].ContainsKey(subKey))
				{
					dictionary_0[mainKey][subKey] = (int)value;
				}
			}
			else if (dictionary_1.ContainsKey(mainKey) && dictionary_1[mainKey].ContainsKey(subKey))
			{
				dictionary_1[mainKey][subKey] = (int)value;
			}
		}

		public void CreateProp(bool isSelf, string skey, int attack, int defence, int agility, int lucky, int hp)
		{
			Dictionary<string, int> dictionary = new Dictionary<string, int>();
			dictionary.Add("Attack", attack);
			dictionary.Add("Defence", defence);
			dictionary.Add("Agility", agility);
			dictionary.Add("Luck", lucky);
			dictionary.Add("HP", hp);
			if (isSelf)
			{
				AddProp(skey, dictionary);
			}
			else
			{
				AddOtherProp(skey, dictionary);
			}
		}

		static PlayerProperty()
		{
			ilog_0 = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
		}
	}
}
