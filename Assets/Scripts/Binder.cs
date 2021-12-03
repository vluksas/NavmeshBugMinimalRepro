using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Binder : MonoBehaviour
{
    [SerializeField] Transform target;

    Vector3 diff;
    private void Start()
    {
        diff = transform.position - target.position;
    }
    // Update is called once per frame
    void Update()
    {
        transform.position = target.position + diff;
    }
}
