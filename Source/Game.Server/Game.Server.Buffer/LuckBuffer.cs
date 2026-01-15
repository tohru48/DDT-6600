using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class LuckBuffer : AbstractBuffer
	{
		public LuckBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(LuckBuffer)) is LuckBuffer luckBuffer)
			{
				luckBuffer.Info.ValidDate += base.Info.ValidDate;
				if (luckBuffer.Info.ValidDate > 30)
				{
					luckBuffer.Info.ValidDate = 30;
				}
				player.BufferList.UpdateBuffer(luckBuffer);
			}
			else
			{
				base.Start(player);
				player.PlayerCharacter.LuckAddPlus = base.Info.Value;
			}
		}

		public override void Stop()
		{
			m_player.PlayerCharacter.LuckAddPlus = 0;
			base.Stop();
		}
	}
}
