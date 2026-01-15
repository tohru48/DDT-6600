using System.Collections.Generic;
using Bussiness;
using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.GameUtils
{
	public class CardInventory : CardAbstractInventory
	{
		protected GamePlayer m_player;

		private bool bool_0;

		private List<UsersCardInfo> list_0;

		public GamePlayer Player => m_player;

		public CardInventory(GamePlayer player, bool saveTodb, int capibility, int beginSlot)
			: base(capibility, beginSlot)
		{
			list_0 = new List<UsersCardInfo>();
			m_player = player;
			bool_0 = saveTodb;
		}

		public virtual void LoadFromDatabase()
		{
			if (!bool_0)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			UsersCardInfo[] userCardSingles = playerBussiness.GetUserCardSingles(m_player.PlayerCharacter.ID);
			BeginChanges();
			try
			{
				UsersCardInfo[] array = userCardSingles;
				foreach (UsersCardInfo usersCardInfo in array)
				{
					AddCardTo(usersCardInfo, usersCardInfo.Place);
				}
			}
			finally
			{
				CommitChanges();
			}
		}

		public virtual void SaveToDatabase()
		{
			if (!bool_0)
			{
				return;
			}
			using PlayerBussiness playerBussiness = new PlayerBussiness();
			lock (m_lock)
			{
				for (int i = 0; i < m_cards.Length; i++)
				{
					UsersCardInfo usersCardInfo = m_cards[i];
					if (usersCardInfo != null && usersCardInfo.IsDirty)
					{
						if (usersCardInfo.CardID > 0)
						{
							playerBussiness.UpdateCards(usersCardInfo);
						}
						else
						{
							playerBussiness.AddCards(usersCardInfo);
						}
					}
				}
			}
			lock (list_0)
			{
				foreach (UsersCardInfo item in list_0)
				{
					if (item.CardID > 0)
					{
						playerBussiness.UpdateCards(item);
					}
				}
				list_0.Clear();
			}
		}

		public override bool AddCardTo(UsersCardInfo item, int place)
		{
			if (base.AddCardTo(item, place))
			{
				item.UserID = m_player.PlayerCharacter.ID;
				item.IsExit = true;
				return true;
			}
			return false;
		}

		public override void UpdateChangedPlaces()
		{
			int[] updatedSlots = m_changedPlaces.ToArray();
			m_player.Out.SendPlayerCardInfo(this, updatedSlots);
			m_player.Out.SendPlayerCardSlot(m_player.PlayerCharacter, GetCards(0, 5));
			base.UpdateChangedPlaces();
		}
	}
}
