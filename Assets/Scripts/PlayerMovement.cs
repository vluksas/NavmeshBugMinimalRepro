using System.Collections;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.UI;
using UnityEngine.InputSystem;

namespace Hokko.Player
{
	public class PlayerMovement : MonoBehaviour {

		public float maxMoveSpeed = 12f;
		private float speedMultiplier = 1;
		NavMeshAgent navAgent;

		Vector2 moveDirection;

		void Awake()
		{
			navAgent = GetComponent<NavMeshAgent>();
		}
	
		void Start()
		{
			navAgent.enabled = false; // Don't enable navagent until we've been placed in the world. Avoids errors with generated nav meshes
		}

		void Update() {
			MovePlayer(moveDirection, Time.deltaTime);
		}

        private void OnMove(InputValue value)
        {
			moveDirection = value.Get<Vector2>().normalized;
			if (!navAgent.enabled)
				navAgent.enabled = true;
        }

        public void MovePlayer(Vector2 direction, float deltaTime, bool ignoreDeadzone = false)
		{
			Vector3 playerDirection = new Vector3(-direction.x, 0, -direction.y);
			playerDirection = Vector3.ClampMagnitude(playerDirection, 1);
	
			
			Vector3 newLocation = transform.position + playerDirection * (maxMoveSpeed * deltaTime * speedMultiplier);
			newLocation = transform.position + playerDirection * (maxMoveSpeed * deltaTime * speedMultiplier);
			navAgent.Warp(newLocation);
		}
		public void Stop()
		{		
			if (navAgent.enabled)
				navAgent.isStopped = true;
		}

	}
}
