using Game.Server.GameObjects;
using SqlDataProvider.Data;

namespace Game.Server.Buffer
{
	public class SaveLifeBuffer : AbstractBuffer
	{
		public SaveLifeBuffer(BufferInfo info)
			: base(info)
		{
		}

		public override void Start(GamePlayer player)
		{
			if (player.BufferList.GetOfType(typeof(SaveLifeBuffer)) is SaveLifeBuffer saveLifeBuffer)
			{
				saveLifeBuffer.Info.ValidCount = m_info.ValidCount;
				player.BufferList.UpdateBuffer(saveLifeBuffer);
			}
			else
			{
				base.Start(player);
			}
		}

		public override void Stop()
		{
			base.Stop();
		}
	}
}
