using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class DefendBuffer : AbstractBuffer
	{
		public DefendBuffer(BufferInfo buffer)
			: base(buffer)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(DefendBuffer)) is DefendBuffer defendBuffer)
			{
				defendBuffer.Info.ValidDate += base.Info.ValidDate;
				if (defendBuffer.Info.ValidDate > 30)
				{
					defendBuffer.Info.ValidDate = 30;
				}
				player.BufferList.UpdateBuffer(defendBuffer);
			}
			else
			{
				base.Start(player);
				player.PlayerCharacter.DefendAddPlus = base.Info.Value;
			}
		}

		public override void Stop()
		{
			m_player.PlayerCharacter.DefendAddPlus = 0;
			base.Stop();
		}
	}
}
