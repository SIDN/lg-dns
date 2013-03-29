package nl.sidn.dnslg.rest.resource;

import java.net.Inet4Address;
import java.net.InetAddress;
import java.util.Date;

import javax.ws.rs.Consumes;
import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.core.Context;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.MultivaluedMap;
import javax.ws.rs.core.Response;
import javax.ws.rs.core.Response.ResponseBuilder;
import javax.ws.rs.core.Response.Status;
import javax.ws.rs.core.UriInfo;

import org.apache.commons.lang.StringUtils;

import com.google.common.net.InetAddresses;

import nl.sidn.dnslib.logic.LookupResult;
import nl.sidn.dnslib.logic.Resolver;
import nl.sidn.dnslib.message.Message;
import nl.sidn.dnslib.message.util.NetworkData;
import nl.sidn.dnslib.message.util.XMLTransformer;
import nl.sidn.dnslib.types.ResourceRecordClass;
import nl.sidn.dnslib.types.ResourceRecordType;
import nl.sidn.dnslib.util.IPUtil;

@Path("/")
@Consumes({MediaType.TEXT_PLAIN, MediaType.APPLICATION_XML, MediaType.APPLICATION_JSON})
public class LGResource {
	
	private @Context HttpHeaders headers;

	@GET
	public Response lookup(){
		ResponseBuilder rBuild = Response.ok("NODATA", MediaType.TEXT_PLAIN_TYPE);
        return rBuild.build();
	}
	
	@Path("/{qName}")
	@GET
	public Response lookupQname(@Context UriInfo ui, @PathParam("qName") String qName){
		MultivaluedMap<String, String> queryParams = ui.getQueryParameters();
		return doLookup(qName, ResourceRecordType.A.name(), queryParams);
	}
	
	@Path("/{qName}/{qType}")
	@GET
	public Response lookupQnameAndType(@Context UriInfo ui,@PathParam("qName") String qName, @PathParam("qType") String qType){
		MultivaluedMap<String, String> queryParams = ui.getQueryParameters();
		return doLookup(qName, qType, queryParams);
				
	}
	
	private Response doLookup(String qName, String qType, MultivaluedMap<String, String> queryParams){
		long start = System.currentTimeMillis();
		
		ResourceRecordType type = ResourceRecordType.fromString(qType);
		if(type == null){
			type = ResourceRecordType.A;
		}
		Resolver r = new Resolver();
		if(queryParams.containsKey("server")){	
			r.setForwardingServer(queryParams.getFirst("server"));
		}
		
		if(queryParams.containsKey("buffersize")){	
			r.setEdnsBufferSize(queryParams.getFirst("buffersize"));
		}
		
		if(queryParams.containsKey("dodnssec") && StringUtils.equals(queryParams.getFirst("dodnssec"), "1")){	
			r.setDnsSecEnabled();
		}
		
		if(queryParams.containsKey("tcp") && StringUtils.equals(queryParams.getFirst("tcp"), "1")){	
			r.setTCPEnabled();
		}
		
		if(queryParams.containsKey("reverse")){	
			try {
				InetAddress ia = InetAddresses.forString(qName);
				
				if(ia instanceof Inet4Address){
					qName = IPUtil.reverseIpv4(qName);
				}else{
					qName = IPUtil.reverseIpv6(IPUtil.normalizeIpv6(qName));
				}
			} catch (Exception e) {
				// not a valid ip
				return Response.status(Status.BAD_REQUEST).build();
			}
		}
		
		LookupResult result = r.lookup(qName, type, ResourceRecordClass.IN, true);
		
		
		//process the result
		
		if(result != null && result.getDatapacketLength() > 0){
			NetworkData nd = new NetworkData(result.getDatapacket());
			Message m = new Message();
			m.decode(nd);
			
			long end = System.currentTimeMillis();
			long duration = end - start;
			
			String data = null;
			MediaType selectedtype = MediaType.TEXT_PLAIN_TYPE;
			if(headers.getAcceptableMediaTypes().contains(MediaType.TEXT_PLAIN_TYPE)){
				data = toZone(start, duration, m);
			}else if(headers.getAcceptableMediaTypes().contains(MediaType.APPLICATION_XML_TYPE)){
				XMLTransformer xmlt = new XMLTransformer();
				data = xmlt.transform(m, start,duration);
				selectedtype = MediaType.APPLICATION_XML_TYPE;
			}else{
			
				//backup
				data = toZone(start, duration, m);
			}
			
			ResponseBuilder rBuild = Response.ok(data, selectedtype);
	        return rBuild.build();
			
		}
		
		ResponseBuilder rBuild = Response.ok(result != null? result.getRcode().name(): "Unknown error", MediaType.TEXT_PLAIN_TYPE);
        return rBuild.build();
	}
	
	private String toZone(long start,long duration, Message m ){
		StringBuffer zone = new StringBuffer();
		zone.append("; start: " + new Date(start) + "\n");
		zone.append("; duration: " + duration + "ms\n");
		zone.append(m.toZone());
		return zone.toString();
	}
	
}
