// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Wonderscope/ProjectionFloors"
{
	Properties
	{
		_MainTex("MainTex", 2D) = "white" {}
		_BumpMap("Normal", 2D) = "bump" {}
		_VColorIntensity("VColorIntensity", Range( 0 , 1)) = 1
		_MetallicGlossMap("Metallic", 2D) = "black" {}
		_Color("Color", Color) = (0,0,0,0)
		_AutumnColor1("AutumnColor", Color) = (0.8396226,0.5022165,0.1069331,1)
		[Toggle]_UseAutumnTex("UseAutumnTex", Range( 0 , 1)) = 0
		_AutumnTex("AutumnTex", 2D) = "white" {}
		_AutumnColorBlend("AutumnColorBlend", Range( 0 , 1)) = 0
		_WinterColor1("WinterColor", Color) = (0.3848789,0.6008307,0.8773585,1)
		_WinterColorBlend("WinterColorBlend", Range( 0 , 1)) = 0
		[Toggle]_SimpleAutumnColor("Simple Autumn Color", Range( 0 , 1)) = 0
		[Toggle]_AffectedBySnow("AffectedBySnow", Range( 0 , 1)) = 0
		_SnowNormalPower("SnowNormalPower", Range( 0 , 20)) = 1
		_SnowIntensityMultiplier("SnowIntensityMultiplier", Range( 0 , 5)) = 1.5
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Back
		CGINCLUDE
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 3.0
		#ifdef UNITY_PASS_SHADOWCASTER
			#undef INTERNAL_DATA
			#undef WorldReflectionVector
			#undef WorldNormalVector
			#define INTERNAL_DATA half3 internalSurfaceTtoW0; half3 internalSurfaceTtoW1; half3 internalSurfaceTtoW2;
			#define WorldReflectionVector(data,normal) reflect (data.worldRefl, half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal)))
			#define WorldNormalVector(data,normal) half3(dot(data.internalSurfaceTtoW0,normal), dot(data.internalSurfaceTtoW1,normal), dot(data.internalSurfaceTtoW2,normal))
		#endif
		struct Input
		{
			float3 worldPos;
			float4 vertexColor : COLOR;
			float2 uv_texcoord;
			float3 worldNormal;
			INTERNAL_DATA
		};

		uniform sampler2D _BumpMap;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform float4 _Color;
		uniform float _VColorIntensity;
		uniform float4 _WinterColor1;
		uniform float _WinterColorBlend;
		uniform float _GlobalSnowAmount;
		uniform float _UseAutumnTex;
		uniform sampler2D _AutumnTex;
		uniform float4 _AutumnTex_ST;
		uniform float4 _AutumnColor1;
		uniform float _SimpleAutumnColor;
		uniform float _AutumnColorBlend;
		uniform float _GlobalAutumnBlend;
		uniform sampler2D _GlobalSnowTexture;
		uniform float4 _GlobalSnowTextureTiling;
		uniform float _SnowNormalPower;
		uniform float _SnowIntensityMultiplier;
		uniform float _AffectedBySnow;
		uniform sampler2D _MetallicGlossMap;
		uniform float _GlobalSnowSmoothness;

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float3 ase_worldPos = i.worldPos;
			float2 appendResult19 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 temp_output_28_0 = ( ( _MainTex_ST.xy * appendResult19 ) + _MainTex_ST.zw );
			float3 normal39 = UnpackNormal( tex2D( _BumpMap, temp_output_28_0 ) );
			o.Normal = normal39;
			float4 tex2DNode1 = tex2D( _MainTex, temp_output_28_0 );
			float4 lerpResult25 = lerp( tex2DNode1 , ( tex2DNode1 * i.vertexColor ) , _VColorIntensity);
			float4 temp_output_1_0_g1 = ( _Color * lerpResult25 );
			float4 lerpResult14_g1 = lerp( temp_output_1_0_g1 , ( temp_output_1_0_g1 * _WinterColor1 ) , ( _WinterColorBlend * _GlobalSnowAmount ));
			float2 uv_AutumnTex = i.uv_texcoord * _AutumnTex_ST.xy + _AutumnTex_ST.zw;
			float4 tex2DNode15_g1 = tex2D( _AutumnTex, uv_AutumnTex );
			float4 lerpResult22_g1 = lerp( ( _AutumnColor1 * lerpResult14_g1 ) , _AutumnColor1 , _SimpleAutumnColor);
			float4 ifLocalVar18_g1 = 0;
			if( _UseAutumnTex >= 1.0 )
				ifLocalVar18_g1 = tex2DNode15_g1;
			else
				ifLocalVar18_g1 = lerpResult22_g1;
			float4 lerpResult20_g1 = lerp( lerpResult14_g1 , ifLocalVar18_g1 , ( _AutumnColorBlend * _GlobalAutumnBlend ));
			float2 appendResult17_g1 = (float2(ase_worldPos.x , ase_worldPos.z));
			float2 appendResult24_g1 = (float2(_GlobalSnowTextureTiling.x , _GlobalSnowTextureTiling.y));
			float4 tex2DNode3_g1 = tex2D( _GlobalSnowTexture, ( appendResult17_g1 * appendResult24_g1 ) );
			float4 snowAlbedo46 = tex2DNode3_g1;
			float snowTexAlpha6_g1 = tex2DNode3_g1.a;
			float3 ase_worldNormal = WorldNormalVector( i, float3( 0, 0, 1 ) );
			float3 ase_normWorldNormal = normalize( ase_worldNormal );
			float dotResult4_g1 = dot( ase_normWorldNormal , float3(0,1,0) );
			float temp_output_8_0_g1 = pow( saturate( dotResult4_g1 ) , _SnowNormalPower );
			float temp_output_26_0_g1 = _SnowIntensityMultiplier;
			float lerpResult12_g1 = lerp( ( snowTexAlpha6_g1 * temp_output_8_0_g1 * temp_output_26_0_g1 ) , 1.0 , temp_output_8_0_g1);
			float snowAmount41 = ( saturate( ( lerpResult12_g1 * temp_output_26_0_g1 * _GlobalSnowAmount ) ) * _AffectedBySnow );
			float4 lerpResult45 = lerp( lerpResult20_g1 , snowAlbedo46 , snowAmount41);
			o.Albedo = lerpResult45.rgb;
			float4 tex2DNode35 = tex2D( _MetallicGlossMap, temp_output_28_0 );
			float lerpResult52 = lerp( tex2DNode35.r , 0.0 , snowAmount41);
			o.Metallic = lerpResult52;
			float lerpResult51 = lerp( tex2DNode35.a , _GlobalSnowSmoothness , snowAmount41);
			o.Smoothness = lerpResult51;
			o.Alpha = 1;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Standard keepalpha fullforwardshadows 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 3.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float2 customPack1 : TEXCOORD1;
				float4 tSpace0 : TEXCOORD2;
				float4 tSpace1 : TEXCOORD3;
				float4 tSpace2 : TEXCOORD4;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				half3 worldTangent = UnityObjectToWorldDir( v.tangent.xyz );
				half tangentSign = v.tangent.w * unity_WorldTransformParams.w;
				half3 worldBinormal = cross( worldNormal, worldTangent ) * tangentSign;
				o.tSpace0 = float4( worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x );
				o.tSpace1 = float4( worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y );
				o.tSpace2 = float4( worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z );
				o.customPack1.xy = customInputData.uv_texcoord;
				o.customPack1.xy = v.texcoord;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv_texcoord = IN.customPack1.xy;
				float3 worldPos = float3( IN.tSpace0.w, IN.tSpace1.w, IN.tSpace2.w );
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.worldNormal = float3( IN.tSpace0.z, IN.tSpace1.z, IN.tSpace2.z );
				surfIN.internalSurfaceTtoW0 = IN.tSpace0.xyz;
				surfIN.internalSurfaceTtoW1 = IN.tSpace1.xyz;
				surfIN.internalSurfaceTtoW2 = IN.tSpace2.xyz;
				surfIN.vertexColor = IN.color;
				SurfaceOutputStandard o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutputStandard, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18800
807;728;1777;822;-916.3878;409.4672;1.444626;True;True
Node;AmplifyShaderEditor.WorldPosInputsNode;17;125.1295,419.7304;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;19;372.493,459.3084;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureTransformNode;27;296.7944,586.4454;Inherit;False;1;False;1;0;SAMPLER2D;;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;18;544.441,436.4645;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleAddOpNode;28;758.1935,516.2138;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.VertexColorNode;23;1094.216,259.0683;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;970.1092,25.37384;Inherit;True;Property;_MainTex;MainTex;0;0;Create;True;0;0;0;True;0;False;-1;None;01ad754846303e44dbba9956dccc623f;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;54;359.6786,-255.065;Inherit;False;Property;_SnowIntensityMultiplier;SnowIntensityMultiplier;17;0;Create;True;0;0;0;False;0;False;1.5;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;43;679.8519,-132.3704;Inherit;False;Property;_AffectedBySnow;AffectedBySnow;13;1;[Toggle];Create;True;0;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;24;1402.566,162.1899;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;22;1306.85,291.1924;Inherit;False;Property;_VColorIntensity;VColorIntensity;2;0;Create;True;0;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;57;692.9872,-249.6953;Inherit;False;GetSnow;14;;1;a6b677fe4d0605d46bde1ae86a5ea4db;0;1;26;FLOAT;1.5;False;2;COLOR;22;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;42;1006.852,-185.3704;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;36;1551.699,-177.259;Inherit;False;Property;_Color;Color;4;0;Create;True;0;0;0;False;0;False;0,0,0,0;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;25;1641.759,34.64155;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;46;1003.198,-286.6908;Inherit;False;snowAlbedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;37;1917.544,13.17355;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;41;1225.852,-255.3704;Inherit;False;snowAmount;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;50;1695.743,984.8377;Inherit;False;Global;_GlobalSnowSmoothness;_GlobalSnowSmoothness;6;0;Create;True;0;0;0;False;0;False;0.1;0.1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;20;1442.455,684.1554;Inherit;True;Property;_BumpMap;Normal;1;0;Create;False;0;0;0;False;0;False;-1;None;578e6316e21d8c747aeec3759f6ca847;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;53;1789.917,370.8224;Inherit;False;41;snowAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;47;2154.62,90.17833;Inherit;False;46;snowAlbedo;1;0;OBJECT;;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;35;1442.317,459.383;Inherit;True;Property;_MetallicGlossMap;Metallic;3;0;Create;False;0;0;0;False;0;False;-1;None;None;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;48;2157.161,179.0993;Inherit;False;41;snowAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;49;1772.143,1077.737;Inherit;False;41;snowAmount;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.FunctionNode;59;2145.031,-18.15498;Inherit;False;SeasonTint;5;;1;1603c31f343d47646b1d6a531b8aebe8;0;1;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.LerpOp;51;2180.144,958.4367;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;52;2012.917,301.8224;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;39;1810.505,693.8912;Inherit;True;normal;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;45;2455.364,46.39281;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;2676.498,149.832;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;Wonderscope/ProjectionFloors;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;19;0;17;1
WireConnection;19;1;17;3
WireConnection;18;0;27;0
WireConnection;18;1;19;0
WireConnection;28;0;18;0
WireConnection;28;1;27;1
WireConnection;1;1;28;0
WireConnection;24;0;1;0
WireConnection;24;1;23;0
WireConnection;57;26;54;0
WireConnection;42;0;57;0
WireConnection;42;1;43;0
WireConnection;25;0;1;0
WireConnection;25;1;24;0
WireConnection;25;2;22;0
WireConnection;46;0;57;22
WireConnection;37;0;36;0
WireConnection;37;1;25;0
WireConnection;41;0;42;0
WireConnection;20;1;28;0
WireConnection;35;1;28;0
WireConnection;59;1;37;0
WireConnection;51;0;35;4
WireConnection;51;1;50;0
WireConnection;51;2;49;0
WireConnection;52;0;35;1
WireConnection;52;2;53;0
WireConnection;39;0;20;0
WireConnection;45;0;59;0
WireConnection;45;1;47;0
WireConnection;45;2;48;0
WireConnection;0;0;45;0
WireConnection;0;1;39;0
WireConnection;0;3;52;0
WireConnection;0;4;51;0
ASEEND*/
//CHKSM=DF8E36ABA0CD8EE465A6B7460B8D669C19AAA2C1