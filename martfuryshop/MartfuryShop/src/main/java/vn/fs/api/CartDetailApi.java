package vn.fs.api;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import vn.fs.entity.CartDetail;
import vn.fs.entity.Product;
import vn.fs.repository.CartDetailRepository;
import vn.fs.repository.CartRepository;
import vn.fs.repository.ProductRepository;

@CrossOrigin("*")
@RestController
@RequestMapping("api/cartDetail")
public class CartDetailApi {

	@Autowired
	CartDetailRepository cartDetailRepository;

	@Autowired
	CartRepository cartRepository;

	@Autowired
	ProductRepository productRepository;



	@GetMapping("cart/{id}")
	public ResponseEntity<List<CartDetail>> getByCartId(@PathVariable("id") Long id) {
		if (!cartRepository.existsById(id)) {
			return ResponseEntity.notFound().build();
		}
		return ResponseEntity.ok(cartDetailRepository.findByCart(cartRepository.findById(id).get()));
	}

	@RequestMapping(value = "{id}", method = RequestMethod.GET)
	public ResponseEntity<CartDetail> getOne(@PathVariable("id") Long id) {
		if (!cartDetailRepository.existsById(id)) {
			return ResponseEntity.notFound().build();
		}
		return ResponseEntity.ok(cartDetailRepository.findById(id).get());
	}

	@PostMapping()
	public ResponseEntity<CartDetail> post(@RequestBody CartDetail detail) {
	    // Kiểm tra xem giỏ hàng có tồn tại hay không
	    if (!cartRepository.existsById(detail.getCart().getCartId())) {
	        return ResponseEntity.notFound().build();
	    }

	    // Tìm sản phẩm với ID và trạng thái true
	    Product product = productRepository.findByProductIdAndStatusTrue(detail.getProduct().getProductId());
	    if (product == null) {
	        return ResponseEntity.notFound().build();
	    }

	    // Kiểm tra số lượng sản phẩm trong kho
	    int requestedQuantity = detail.getQuantity();
	    if (requestedQuantity > product.getQuantity()) {
	        return ResponseEntity.badRequest().body(null); // Trả về lỗi nếu yêu cầu vượt quá số lượng hiện có
	    }

	    // Lấy danh sách chi tiết giỏ hàng hiện tại
	    List<CartDetail> listD = cartDetailRepository.findByCart(cartRepository.findById(detail.getCart().getCartId()).get());

	    for (CartDetail item : listD) {
	        // Nếu sản phẩm đã có trong giỏ hàng, cập nhật số lượng và giá
	        if (item.getProduct().getProductId().equals(detail.getProduct().getProductId())) {
	            int newQuantity = item.getQuantity() + requestedQuantity;
	            if (newQuantity > product.getQuantity()) {
	                return ResponseEntity.badRequest().body(null); // Trả về lỗi nếu tổng số lượng vượt quá số lượng hiện có
	            }
	            item.setQuantity(newQuantity);
	            item.setPrice(item.getPrice() + detail.getPrice());
	            return ResponseEntity.ok(cartDetailRepository.save(item));
	        }
	    }

	    // Nếu sản phẩm chưa có trong giỏ hàng, thêm sản phẩm mới
	    return ResponseEntity.ok(cartDetailRepository.save(detail));
	}


	@PutMapping()
	public ResponseEntity<CartDetail> put(@RequestBody CartDetail detail) {
		if (!cartRepository.existsById(detail.getCart().getCartId())) {
			return ResponseEntity.notFound().build();
		}
		return ResponseEntity.ok(cartDetailRepository.save(detail));
	}

	@DeleteMapping("{id}")
	public ResponseEntity<Void> delete(@PathVariable("id") Long id) {
		if (!cartDetailRepository.existsById(id)) {
			return ResponseEntity.notFound().build();
		}
		cartDetailRepository.deleteById(id);
		return ResponseEntity.ok().build();
	}



}
