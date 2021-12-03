using UnityEngine;
using UnityEngine.AI;

namespace Hokko.World
{
	public class NavBaker : MonoBehaviour
	{
		public bool baked;
        void Start()
        {
			Bake();
        }
        private void OnDestroy()
        {
			Clear();
        }
        public void Bake()
		{
			GetComponent<NavMeshSurface>().BuildNavMesh();
			baked = true;
		}

		public void Clear()
		{
			GetComponent<NavMeshSurface>().RemoveData();
		}
	}
}